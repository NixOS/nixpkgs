{ supportedSystems ? [ builtins.currentSystem ] }:

with {
  inherit (builtins) getAttr;
  inherit (import ../attrsets.nix) mapAttrs genAttrs isDerivation;
  inherit (import ../customisation.nix) hydraJob;
  inherit (import ../trivial.nix) id;
};

rec {

  /* Call a test file

     The called test file should contain a function that returns:
     - a single test set
     - a set of tests sets
     - a test derivation, eg runInMachine

     Examples:

     a. Call a test:
       callTest ./nixos/tests/simple.nix {};

     b. Call a test for only x86_64-linux:
       callTest ./nixos/tests/simple.nix { systems = [ "x86_64-linux" ]; };

     c. Call a test with custom parameters:
       callTest ./nixos/tests/nfs.nix { version = 3; };

     d. Call a test from the command line with nix-build:
       $ nix-build -E 'with import <nixpkgs/lib/testing> {}; callTest ./nixos/tests/simple.nix {}'

  */

  callTest = file: { systems ? supportedSystems, interactive ? false, ... } @ args:
    let
      # raw test function
      testFn = import file;
      # pkgs needed to dummy evaluate the test, not used in the final test
      pkgs = import ../.. { system = "x86_64-linux"; };
      # basic arguments
      testArgs = rec { inherit pkgs; inherit (pkgs) lib; } // args;
      # test applied with basic arguments
      dummyTest = testFn testArgs;
      # check if the test is a derivation like in runInMachine
      drvTest = isDerivation dummyTest;
      # to check if it is a single test or multiple tests
      singleTest = dummyTest ? "testScript";
      # generate the tests with makeTest function
      mkTest = { system ? builtins.currentSystem, ... } @ args:
        let testLib = import ./testing.nix { inherit system; };
            # pkgs coming from testing.nix for the system tested
            pkgsSet = { inherit testLib pkgs; };
            test = testFn (args // pkgsSet);
        in if drvTest then test
              else if singleTest
                   then testLib.makeTest test
                   else mapAttrs (k: v: testLib.makeTest v) test;
      # function to prepare the test
      prepTestFn = if interactive
                   then (getAttr "driver")
                   else hydraJob;
      # check unsupported cases
      runCheck = f: if (drvTest && interactive)
                 then builtins.abort "Derivation tests cannot be run interactively"
                 else f;
      # generate test jobs for systems
      testForSys = f: genAttrs systems (system: prepTestFn( f( mkTest({ inherit system; } // testArgs)) ) );
      # fully prepared test
      test = if (drvTest || singleTest)
                then testForSys id
                else mapAttrs (k: _: testForSys (getAttr k)) dummyTest;
      in runCheck test;

}
