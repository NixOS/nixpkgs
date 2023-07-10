# Unit tests for lib.path functions. Use `nix-build` in this directory to
# run these
{ libpath }:
let
  lib = import libpath;
  inherit (lib.path) hasPrefix append subpath;

  cases = lib.runTests {
    # Test examples from the lib.path.append documentation
    testAppendExample1 = {
      expr = append /foo "bar/baz";
      expected = /foo/bar/baz;
    };
    testAppendExample2 = {
      expr = append /foo "./bar//baz/./";
      expected = /foo/bar/baz;
    };
    testAppendExample3 = {
      expr = append /. "foo/bar";
      expected = /foo/bar;
    };
    testAppendExample4 = {
      expr = (builtins.tryEval (append "/foo" "bar")).success;
      expected = false;
    };
    testAppendExample5 = {
      expr = (builtins.tryEval (append /foo /bar)).success;
      expected = false;
    };
    testAppendExample6 = {
      expr = (builtins.tryEval (append /foo "")).success;
      expected = false;
    };
    testAppendExample7 = {
      expr = (builtins.tryEval (append /foo "/bar")).success;
      expected = false;
    };
    testAppendExample8 = {
      expr = (builtins.tryEval (append /foo "../bar")).success;
      expected = false;
    };

    testHasPrefixExample1 = {
      expr = hasPrefix /foo /foo/bar;
      expected = true;
    };
    testHasPrefixExample2 = {
      expr = hasPrefix /foo /foo;
      expected = true;
    };
    testHasPrefixExample3 = {
      expr = hasPrefix /foo/bar /foo;
      expected = false;
    };
    testHasPrefixExample4 = {
      expr = hasPrefix /. /foo;
      expected = true;
    };

    # Test examples from the lib.path.subpath.isValid documentation
    testSubpathIsValidExample1 = {
      expr = subpath.isValid null;
      expected = false;
    };
    testSubpathIsValidExample2 = {
      expr = subpath.isValid "";
      expected = false;
    };
    testSubpathIsValidExample3 = {
      expr = subpath.isValid "/foo";
      expected = false;
    };
    testSubpathIsValidExample4 = {
      expr = subpath.isValid "../foo";
      expected = false;
    };
    testSubpathIsValidExample5 = {
      expr = subpath.isValid "foo/bar";
      expected = true;
    };
    testSubpathIsValidExample6 = {
      expr = subpath.isValid "./foo//bar/";
      expected = true;
    };
    # Some extra tests
    testSubpathIsValidTwoDotsEnd = {
      expr = subpath.isValid "foo/..";
      expected = false;
    };
    testSubpathIsValidTwoDotsMiddle = {
      expr = subpath.isValid "foo/../bar";
      expected = false;
    };
    testSubpathIsValidTwoDotsPrefix = {
      expr = subpath.isValid "..foo";
      expected = true;
    };
    testSubpathIsValidTwoDotsSuffix = {
      expr = subpath.isValid "foo..";
      expected = true;
    };
    testSubpathIsValidTwoDotsPrefixComponent = {
      expr = subpath.isValid "foo/..bar/baz";
      expected = true;
    };
    testSubpathIsValidTwoDotsSuffixComponent = {
      expr = subpath.isValid "foo/bar../baz";
      expected = true;
    };
    testSubpathIsValidThreeDots = {
      expr = subpath.isValid "...";
      expected = true;
    };
    testSubpathIsValidFourDots = {
      expr = subpath.isValid "....";
      expected = true;
    };
    testSubpathIsValidThreeDotsComponent = {
      expr = subpath.isValid "foo/.../bar";
      expected = true;
    };
    testSubpathIsValidFourDotsComponent = {
      expr = subpath.isValid "foo/..../bar";
      expected = true;
    };

    # Test examples from the lib.path.subpath.join documentation
    testSubpathJoinExample1 = {
      expr = subpath.join [ "foo" "bar/baz" ];
      expected = "./foo/bar/baz";
    };
    testSubpathJoinExample2 = {
      expr = subpath.join [ "./foo" "." "bar//./baz/" ];
      expected = "./foo/bar/baz";
    };
    testSubpathJoinExample3 = {
      expr = subpath.join [ ];
      expected = "./.";
    };
    testSubpathJoinExample4 = {
      expr = (builtins.tryEval (subpath.join [ /foo ])).success;
      expected = false;
    };
    testSubpathJoinExample5 = {
      expr = (builtins.tryEval (subpath.join [ "" ])).success;
      expected = false;
    };
    testSubpathJoinExample6 = {
      expr = (builtins.tryEval (subpath.join [ "/foo" ])).success;
      expected = false;
    };
    testSubpathJoinExample7 = {
      expr = (builtins.tryEval (subpath.join [ "../foo" ])).success;
      expected = false;
    };

    # Test examples from the lib.path.subpath.normalise documentation
    testSubpathNormaliseExample1 = {
      expr = subpath.normalise "foo//bar";
      expected = "./foo/bar";
    };
    testSubpathNormaliseExample2 = {
      expr = subpath.normalise "foo/./bar";
      expected = "./foo/bar";
    };
    testSubpathNormaliseExample3 = {
      expr = subpath.normalise "foo/bar";
      expected = "./foo/bar";
    };
    testSubpathNormaliseExample4 = {
      expr = subpath.normalise "foo/bar/";
      expected = "./foo/bar";
    };
    testSubpathNormaliseExample5 = {
      expr = subpath.normalise "foo/bar/.";
      expected = "./foo/bar";
    };
    testSubpathNormaliseExample6 = {
      expr = subpath.normalise ".";
      expected = "./.";
    };
    testSubpathNormaliseExample7 = {
      expr = (builtins.tryEval (subpath.normalise "foo/../bar")).success;
      expected = false;
    };
    testSubpathNormaliseExample8 = {
      expr = (builtins.tryEval (subpath.normalise "")).success;
      expected = false;
    };
    testSubpathNormaliseExample9 = {
      expr = (builtins.tryEval (subpath.normalise "/foo")).success;
      expected = false;
    };
    # Some extra tests
    testSubpathNormaliseIsValidDots = {
      expr = subpath.normalise "./foo/.bar/.../baz...qux";
      expected = "./foo/.bar/.../baz...qux";
    };
    testSubpathNormaliseWrongType = {
      expr = (builtins.tryEval (subpath.normalise null)).success;
      expected = false;
    };
    testSubpathNormaliseTwoDots = {
      expr = (builtins.tryEval (subpath.normalise "..")).success;
      expected = false;
    };

    testSubpathComponentsExample1 = {
      expr = subpath.components ".";
      expected = [ ];
    };
    testSubpathComponentsExample2 = {
      expr = subpath.components "./foo//bar/./baz/";
      expected = [ "foo" "bar" "baz" ];
    };
    testSubpathComponentsExample3 = {
      expr = (builtins.tryEval (subpath.components "/foo")).success;
      expected = false;
    };
  };
in
  if cases == [] then "Unit tests successful"
  else throw "Path unit tests failed: ${lib.generators.toPretty {} cases}"
