{ lib }:
let
  inherit (builtins) attrNames trace substring;
  inherit (lib) elem;
in

rec {

  # -- TESTING --

  /* Evaluate a set of tests.  A test is an attribute set {expr,
     expected}, denoting an expression and its expected result.  The
     result is a list of failed tests, each represented as {name,
     expected, actual}, denoting the attribute name of the failing
     test and its expected and actual results.  Used for regression
     testing of the functions in lib; see tests.nix for an example.
     Only tests having names starting with "test" are run.
     Add attr { tests = ["testName"]; } to run these test only
  */
  runTests = tests: lib.concatLists (lib.attrValues (lib.mapAttrs (name: test:
    let testsToRun = if tests ? tests then tests.tests else [];
    in if (substring 0 4 name == "test" ||  elem name testsToRun)
       && ((testsToRun == []) || elem name tests.tests)
       && (test.expr != test.expected)

      then [ { inherit name; expected = test.expected; result = test.expr; } ]
      else [] ) tests));

  # create a test assuming that list elements are true
  # usage: { testX = allTrue [ true ]; }
  testAllTrue = expr: { inherit expr; expected = map (x: true) expr; };

  # -- DEPRECATED --

  attrNamesToStr = a:
    trace ( "Warning: `attrNamesToStr` is deprecated "
          + "and will be removed in the next release. "
          + "Please use more specific concatenation "
          + "for your uses (`lib.concat(Map)StringsSep`)." )
    (lib.concatStringsSep "; " (map (x: "${x}=") (attrNames a)));

  addErrorContextToAttrs = attrs:
    trace ( "Warning: `addErrorContextToAttrs` is deprecated "
          + "and will be removed in the next release. "
          + "Please use `builtins.addErrorContext` directly." )
    (lib.mapAttrs (a: v: lib.addErrorContext "while evaluating ${a}" v) attrs);

}
