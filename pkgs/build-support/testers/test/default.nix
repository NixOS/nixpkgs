{ testers, lib, pkgs, hello, runCommand, ... }:
let
  pkgs-with-overlay = pkgs.extend(final: prev: {
    proof-of-overlay-hello = prev.hello;
  });

  dummyVersioning = {
    revision = "test";
    versionSuffix = "test";
    label = "test";
  };

in
lib.recurseIntoAttrs {
  # Check that the wiring of nixosTest is correct.
  # Correct operation of the NixOS test driver should be asserted elsewhere.
  nixosTest-example = pkgs-with-overlay.testers.nixosTest ({ lib, pkgs, figlet, ... }: {
    name = "nixosTest-test";
    nodes.machine = { pkgs, ... }: {
      system.nixos = dummyVersioning;
      environment.systemPackages = [ pkgs.proof-of-overlay-hello figlet ];
    };
    testScript = ''
      machine.succeed("hello | figlet >/dev/console")
    '';
  });

  testBuildFailure = lib.recurseIntoAttrs {
    happy = runCommand "testBuildFailure-happy" {
      failed = testers.testBuildFailure (runCommand "fail" {} ''
        echo ok-ish >$out
        echo failing though
        echo also stderr 1>&2
        exit 3
      '');
    } ''
      grep -F 'failing though' $failed/testBuildFailure.log
      grep -F 'also stderr' $failed/testBuildFailure.log
      grep -F 'ok-ish' $failed/result
      [[ 3 = $(cat $failed/testBuildFailure.exit) ]]
      touch $out
    '';

    helloDoesNotFail = runCommand "testBuildFailure-helloDoesNotFail" {
      failed = testers.testBuildFailure (testers.testBuildFailure hello);

      # Add hello itself as a prerequisite, so we don't try to run this test if
      # there's an actual failure in hello.
      inherit hello;
    } ''
      echo "Checking $failed/testBuildFailure.log"
      grep -F 'testBuildFailure: The builder did not fail, but a failure was expected' $failed/testBuildFailure.log
      [[ 1 = $(cat $failed/testBuildFailure.exit) ]]
      touch $out
    '';

    multiOutput = runCommand "testBuildFailure-multiOutput" {
      failed = testers.testBuildFailure (runCommand "fail" {
        # dev will be the default output
        outputs = ["dev" "doc" "out"];
      } ''
        echo i am failing
        exit 1
      '');
    } ''
      grep -F 'i am failing' $failed/testBuildFailure.log >/dev/null
      [[ 1 = $(cat $failed/testBuildFailure.exit) ]]

      # Checking our note that dev is the default output
      echo $failed/_ | grep -- '-dev/_' >/dev/null

      touch $out
    '';
  };

}
