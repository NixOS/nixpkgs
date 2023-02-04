# Unit tests for lib.path functions. Use `nix-build` in this directory to
# run these
{ libpath }:
let
  lib = import libpath;
  inherit (lib.path) subpath;

  cases = lib.runTests {
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
  };
in
  if cases == [] then "Unit tests successful"
  else throw "Path unit tests failed: ${lib.generators.toPretty {} cases}"
