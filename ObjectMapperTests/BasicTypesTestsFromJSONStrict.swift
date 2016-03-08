//
//  BasicTypesFromJSON.swift
//  ObjectMapper
//
//  Created by Ole Krause-Sparmann on 2016-03-08.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2014-2015 Hearst
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation
import XCTest
import ObjectMapper

class SomeImplicityUnwrappedTypes: Mappable {
	var boolImplicityUnwrapped: Bool!
	var intImplicityUnwrapped: Int!
	var doubleImplicityUnwrapped: Double!
	
	init(){
		
	}
	
	required init?(_ map: Map){
		
	}
	
	func mapping(map: Map) {
		boolImplicityUnwrapped				<- map["boolImp"]
		intImplicityUnwrapped				<- map["intImp"]
		doubleImplicityUnwrapped			<- map["doubleImp"]
	}
}


class BasicTypesTestsFromJSONStrict: XCTestCase {
	
	// We use a strict mapper here. In case of missing implictly unwrapper optionals map() should return nil.
	let mapper = Mapper<SomeImplicityUnwrappedTypes>(strict: true)
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	// MARK: Test that if values for implicitly unwrapped optionals are missing, parsing fails!
	
	func testMappingBoolFromJSON(){
		let boolValue: Bool = true
		let intValue: Int = 1
		let doubleValue: Double = 1.0
		let JSONString = "{\"boolImp\" : \(boolValue), \"intImp\" : \(intValue), \"doubleImp\" : \(doubleValue)}"
		
		let mappedObject = mapper.map(JSONString)
		
		XCTAssertNotNil(mappedObject)
		XCTAssertEqual(mappedObject?.boolImplicityUnwrapped, boolValue)
		XCTAssertEqual(mappedObject?.intImplicityUnwrapped, intValue)
		XCTAssertEqual(mappedObject?.doubleImplicityUnwrapped, doubleValue)
		
		// Parsing and mapping this JSON string should fail because a key for an implicitly unwrapper optional property is missing.
		
		let JSONStringWithMissingKey = "{\"boolImp\" : \(boolValue), \"doubleImp\" : \(doubleValue)}"
		
		let failedObject = mapper.map(JSONStringWithMissingKey)
		
		XCTAssertNil(failedObject)
	}

}
