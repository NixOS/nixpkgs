{ testers, lib, pkgs, hello, runCommand, emptyFile, emptyDirectory, ... }:
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
  lycheeLinkCheck = lib.recurseIntoAttrs pkgs.lychee.tests;

  hasPkgConfigModules = pkgs.callPackage ../hasPkgConfigModules/tests.nix { };

  shellcheck = pkgs.callPackage ../shellcheck/tests.nix { };

  runCommand = lib.recurseIntoAttrs {
    bork = pkgs.python3Packages.bork.tests.pytest-network;

    dns-resolution = testers.runCommand {
      name = "runCommand-dns-resolution-test";
      nativeBuildInputs = [ pkgs.ldns ];
      script = ''
        drill example.com
        touch $out
      '';
    };

    nonDefault-hash = testers.runCommand {
      name = "runCommand-nonDefaultHash-test";
      script = ''
        mkdir $out
        touch $out/empty
        echo aaaaaaaaaaicjnrkeflncmrlk > $out/keymash
      '';
      hash = "sha256-eMy+6bkG+KS75u7Zt4PM3APhtdVd60NxmBRN5GKJrHs=";
    };
  };

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
  nixosTest-example = pkgs-with-overlay.testers.nixosTest ({ lib, ... }: {
    name = "nixosTest-test";
    nodes.machine = { pkgs, ... }: {
      system.nixos = dummyVersioning;
      environment.systemPackages = [ pkgs.proof-of-overlay-hello pkgs.figlet ];
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
    equalDir = testers.testEqualContents {
      assertion = "The same directory contents at different paths are recognized as equal";
      expected = runCommand "expected" { } ''
        mkdir -p -- "$out/c"
        echo a >"$out/a"
        echo b >"$out/b"
        echo d >"$out/c/d"
        echo e >"$out/e"
        chmod a+x -- "$out/e"
      '';
      actual = runCommand "actual" { } ''
        mkdir -p -- "$out/c"
        echo a >"$out/a"
        echo b >"$out/b"
        echo d >"$out/c/d"
        echo e >"$out/e"
        chmod a+x -- "$out/e"
      '';
    };

    fileMissing = testers.testBuildFailure (
      testers.testEqualContents {
        assertion = "Directories with different file list are not recognized as equal";
        expected = runCommand "expected" { } ''
          mkdir -p -- "$out/c"
          echo a >"$out/a"
          echo b >"$out/b"
          echo d >"$out/c/d"
        '';
        actual = runCommand "actual" { } ''
          mkdir -p -- "$out/c"
          echo a >"$out/a"
          echo d >"$out/c/d"
        '';
      }
    );

    equalExe = testers.testEqualContents {
      assertion = "The same executable file contents at different paths are recognized as equal";
      expected = runCommand "expected" { } ''
        echo test >"$out"
        chmod a+x -- "$out"
      '';
      actual = runCommand "actual" { } ''
        echo test >"$out"
        chmod a+x -- "$out"
      '';
    };

    unequalExe = testers.testBuildFailure (
      testers.testEqualContents {
        assertion = "Different file mode bits are not recognized as equal";
        expected = runCommand "expected" { } ''
          touch -- "$out"
          chmod a+x -- "$out"
        '';
        actual = runCommand "actual" { } ''
          touch -- "$out"
        '';
      }
    );

    unequalExeInDir = testers.testBuildFailure (
      testers.testEqualContents {
        assertion = "Different file mode bits are not recognized as equal in directory";
        expected = runCommand "expected" { } ''
          mkdir -p -- "$out/a"
          echo b >"$out/b"
          chmod a+x -- "$out/b"
        '';
        actual = runCommand "actual" { } ''
          mkdir -p -- "$out/a"
          echo b >"$out/b"
        '';
      }
    );

    nonExistentPath = testers.testBuildFailure (
      testers.testEqualContents {
        assertion = "Non existent paths are not recognized as equal";
        expected = "${emptyDirectory}/foo";
        actual = "${emptyDirectory}/bar";
      }
    );

    emptyFileAndDir = testers.testBuildFailure (
      testers.testEqualContents {
        assertion = "Empty file and directory are not recognized as equal";
        expected = emptyFile;
        actual = emptyDirectory;
      }
    );

    fileDiff =
      let
        log = testers.testBuildFailure (
          testers.testEqualContents {
            assertion = "Different files are not recognized as equal in subdirectories";
            expected = runCommand "expected" { } ''
              mkdir -p -- "$out/b"
              echo a >"$out/a"
              echo EXPECTED >"$out/b/c"
            '';
            actual = runCommand "actual" { } ''
              mkdir -p "$out/b"
              echo a >"$out/a"
              echo ACTUAL >"$out/b/c"
            '';
          }
        );
      in
      runCommand "testEqualContents-fileDiff" { inherit log; } ''
        (
          set -x
          # Note: use `&&` operator to chain commands because errexit (set -e)
          # does not work in this context (even when set explicitly and with
          # inherit_errexit), otherwise the subshell exits with the status of
          # the last run command and ignores preceding failures.
          grep -F -- 'Contents must be equal, but were not!' "$log/testBuildFailure.log" &&
          grep -E -- '\+\+\+ .*-expected/b/c' "$log/testBuildFailure.log" &&
          grep -E -- '--- .*-actual/b/c' "$log/testBuildFailure.log" &&
          grep -F -- -ACTUAL "$log/testBuildFailure.log" &&
          grep -F -- +EXPECTED "$log/testBuildFailure.log"
        ) || {
          echo "Test failed: could not find pattern in build log $log"
          false
        }
        echo 'All good.'
        touch -- "$out"
      '';
  };
}
