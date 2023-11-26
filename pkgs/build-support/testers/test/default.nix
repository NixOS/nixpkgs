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
  hasPkgConfigModules = pkgs.callPackage ../hasPkgConfigModules/tests.nix { };

  runNixOSTest-example = pkgs-with-overlay.testers.runNixOSTest ({ lib, ... }: {
    name = "runNixOSTest-test";
    nodes.machine = { pkgs, ... }: {
      system.nixos = dummyVersioning;
      environment.systemPackages = [ pkgs.proof-of-overlay-hello pkgs.figlet ];
    };
    testScript = ''
      machine.succeed("hello | figlet >/dev/console")
    '';
  });

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
        echo 'line\nwith-\bbackslashes'
        printf "incomplete line - no newline"

        exit 3
      '');
    } ''
      grep -F 'ok-ish' $failed/result

      grep -F 'failing though' $failed/testBuildFailure.log
      grep -F 'also stderr' $failed/testBuildFailure.log
      grep -F 'line\nwith-\bbackslashes' $failed/testBuildFailure.log
      grep -F 'incomplete line - no newline' $failed/testBuildFailure.log

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
      grep -F 'testBuildFailure: The builder did not fail, but a failure was expected' $failed/testBuildFailure.log >/dev/null
      [[ 1 = $(cat $failed/testBuildFailure.exit) ]]
      touch $out
      echo 'All good.'
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
      echo 'All good.'
      touch $out
    '';
  };

  testEqualContents = lib.recurseIntoAttrs {
    happy = testers.testEqualContents {
      assertion = "The same directory contents at different paths are recognized as equal";
      expected = runCommand "expected" {} ''
        mkdir -p $out/c
        echo a >$out/a
        echo b >$out/b
        echo d >$out/c/d
      '';
      actual = runCommand "actual" {} ''
        mkdir -p $out/c
        echo a >$out/a
        echo b >$out/b
        echo d >$out/c/d
      '';
    };

    unequalExe =
      runCommand "testEqualContents-unequalExe" {
        log = testers.testBuildFailure (testers.testEqualContents {
          assertion = "The same directory contents at different paths are recognized as equal";
          expected = runCommand "expected" {} ''
            mkdir -p $out/c
            echo a >$out/a
            chmod a+x $out/a
            echo b >$out/b
            echo d >$out/c/d
          '';
          actual = runCommand "actual" {} ''
            mkdir -p $out/c
            echo a >$out/a
            echo b >$out/b
            chmod a+x $out/b
            echo d >$out/c/d
          '';
        });
      } ''
        (
          set -x
          grep -F -- "executable bits don't match" $log/testBuildFailure.log
          grep -E -- '+.*-actual/a' $log/testBuildFailure.log
          grep -E -- '-.*-actual/b' $log/testBuildFailure.log
          grep -F -- "--- actual-executables" $log/testBuildFailure.log
          grep -F -- "+++ expected-executables" $log/testBuildFailure.log
        ) || {
          echo "Test failed: could not find pattern in build log $log"
          exit 1
        }
        echo 'All good.'
        touch $out
      '';

    fileDiff =
      runCommand "testEqualContents-fileDiff" {
        log = testers.testBuildFailure (testers.testEqualContents {
          assertion = "The same directory contents at different paths are recognized as equal";
          expected = runCommand "expected" {} ''
            mkdir -p $out/c
            echo a >$out/a
            echo b >$out/b
            echo d >$out/c/d
          '';
          actual = runCommand "actual" {} ''
            mkdir -p $out/c
            echo a >$out/a
            echo B >$out/b
            echo d >$out/c/d
          '';
        });
      } ''
        (
          set -x
          grep -F -- "Contents must be equal but were not" $log/testBuildFailure.log
          grep -E -- '+++ .*-actual/b' $log/testBuildFailure.log
          grep -E -- '--- .*-actual/b' $log/testBuildFailure.log
          grep -F -- "-B" $log/testBuildFailure.log
          grep -F -- "+b" $log/testBuildFailure.log
        ) || {
          echo "Test failed: could not find pattern in build log $log"
          exit 1
        }
        echo 'All good.'
        touch $out
      '';

    fileMissing =
      runCommand "testEqualContents-fileMissing" {
        log = testers.testBuildFailure (testers.testEqualContents {
          assertion = "The same directory contents at different paths are recognized as equal";
          expected = runCommand "expected" {} ''
            mkdir -p $out/c
            echo a >$out/a
            echo b >$out/b
            echo d >$out/c/d
          '';
          actual = runCommand "actual" {} ''
            mkdir -p $out/c
            echo a >$out/a
            echo d >$out/c/d
          '';
        });
      } ''
        (
          set -x
          grep -F -- "Contents must be equal but were not" $log/testBuildFailure.log
          grep -E -- 'Only in .*-expected: b' $log/testBuildFailure.log
        ) || {
          echo "Test failed: could not find pattern in build log $log"
          exit 1
        }
        echo 'All good.'
        touch $out
      '';
  };
}
