# tests for /lib/types-simple
let lib = import ../default.nix;
in with lib.types-simple;

let

  # Generate a type checker error.
  # expectedType is the type expected at that position
  # val is the value that was badly typed
  err = expectedType: val: {
    inherit val;
    should = expectedType.description;
  };
  # a successful type check
  ok = {};

  # Test the checkType function results.
  # type is the type to check for
  # val is the value that should be of type type
  # result is the expected checkType result
  test = type: val: result: {
    expr = checkType type val;
    expected = result;
  };

  # TODO test the return type of checkType to be
  # nested attrs (product { should = string; val = any; })

in lib.runTests {

  testVoid = test void 23 (err void 23);

  testAnyInt = test any 42 ok;
  testAnyString = test any "foo" ok;
  testAnyList = test any [ 3 "45" { dont = "do this"; } "ever" ] ok;

  testUnitOk = test unit {} ok;
  testUnitFoo = test unit "foo" (err unit "foo");

  testBoolOk = test bool true ok;
  testBoolFoo = test bool 23 (err bool 23);

  testStringOk = test string "foo" ok;
  testStringFoo = test string false (err string false);

  testIntOk = test int 42 ok;
  testIntFoo = test int {} (err int {});

  testFloatOk = test float 3.14 ok;
  testFloatOkStrange = test float 23. ok;
  testFloatNotInt = test float 23 (err float 23);
  testFloatFoo = test float [ "nope" ] (err float [ "nope" ]);

  testListEmpty = test (list void) [] ok;
  testListIntOk = test (list int) [ 1 2 3 ] ok;
  testListPosFoo = test (list int) [ 1 "ahh" 3 true ] {
    "1" = (err int "ahh");
    "3" = (err int true);
  };
  testListOfListUnitOk = test (list (list unit)) [ [] [{}] [{} {} {}] ] ok;
  testListOfListUnitFoo = test (list (list unit)) [ {} [ {} "ups" ] [[]] ] {
    "0" = err (list unit) {};
    "1"."1" = err unit "ups";
    "2"."0" = err unit [];
   };

  testAttrsEmpty = test (attrs void) {} ok;
  testAttrsIntOk = test (attrs int) { foo = 1; bar = 2; } ok;
  testAttrsIntListFoo = test (attrs int) [] (err (attrs int) []);
  testAttrsIntFoo = test (attrs int) { foo.bar = 1; baz = 2; quux = true; } {
    foo = err int { bar = 1; };
    quux = err int true;
  };
  testAttrsOfAttrsOk = test (attrs (attrs unit)) { foo.bar = {}; baz.quux = {}; } ok;
  testAttrsOfAttrsEmptyOk = test (attrs (attrs unit)) {} ok;
  testAttrsOfAttrsFoo = test (attrs (attrs unit)) { a = []; b.c.d.e = false; } {
    a = err (attrs unit) [];
    b.c = err unit { d.e = false; };
  };

  testListOfAttrsOk1 = test (list (attrs unit)) [] ok;
  testListOfAttrsOk2 = test (list (attrs unit)) [ { a = {}; } { b = {}; } ] ok;
  testListOfAttrsFoo = test (list (attrs unit))
    [ 42 { a = {}; b.c.d = "x"; } { x = []; } {} ]
    {
      "0" = err (attrs unit) 42;
      "1".b = err unit { c.d = "x"; };
      "2".x = err unit [];
    };

  testProductOk = test (product { name = string; age = int; })
    { name = "hans"; age = 42; } ok;
  testProductWrongTypes = test (product { name = string; age = int; })
    { name = true; age = 23.5; }
    {
      name = err string true;
      age = err int 23.5;
    };
  testProductWrongField = test (product { foo = bool; })
    { bar = "foo"; }
    (err (product { foo = bool; }) { bar = "foo"; });
  testProductTooManyFields = test (product { a = int; b = int; })
    { a = 1; b = 2; c = "hello"; }
    (err (product { a = int; b = int; }) { a = 1; b = 2; c = "hello"; });
  testProductEmptyOk = test (product {}) {} ok;
  testProductEmptyFoo = test (product {}) { name = "hans"; }
    (err (product {}) { name = "hans"; });

  testSumLeftOk = test (sum { left = string; right = unit; })
    { left = "errör!"; } ok;
  testSumRightOk = test (sum { left = string; right = unit; })
    { right = {}; } ok;
  testSumWrongField = test (sum { a = int; b = bool; })
    { c = "ups"; }
    (err (sum { a = int; b = bool; }) { c = "ups"; });
  testSumIsNotUnion = test (sum { a = string; b = int; })
    42
    (err (sum { a = string; b = int; }) 42);
  testSumTooManyFields = test (sum { a = int; b = unit; })
    { a = 21; b = {}; }
    (err (sum { a = int; b = unit; }) { a = 21; b = {}; });

  testUnionOk1 = test (union [ int string (list unit) ]) 23 ok;
  testUnionOk2 = test (union [ int string (list unit) ]) "foo" ok;
  testUnionOk3 = test (union [ int string (list unit) ]) [{}{}] ok;
  testUnionWrongType = test (union [ int string ]) true
    (err (union [ int string ]) true);
  testUnionOne = test (union [ int ]) 23 ok;

}
