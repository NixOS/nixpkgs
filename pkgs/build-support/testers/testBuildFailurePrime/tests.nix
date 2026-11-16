{
  emptyDirectory,
  hello,
  lib,
  overrideStructuredAttrs,
  runCommand,
  stdenvNoCC,
  testers,
}:
let
  inherit (lib.attrsets) recurseIntoAttrs;
  final = {
    # NOTE: This example is used in the docs.
    # See https://nixos.org/manual/nixpkgs/unstable/#tester-testBuildFailurePrime
    # or doc/build-helpers/testers.chapter.md
    doc-example = testers.testBuildFailure' {
      drv = runCommand "doc-example" { } ''
        echo ok-ish >"$out"
        echo failing though
        exit 3
      '';
      expectedBuilderExitCode = 3;
      expectedBuilderLogEntries = [ "failing though" ];
      script = ''
        grep --silent -F 'ok-ish' "$failed/result"
      '';
    };

    happy = testers.testBuildFailure' {
      drv = runCommand "happy" { } ''
        echo ok-ish >$out

        echo failing though
        echo also stderr 1>&2
        echo 'line\nwith-\bbackslashes'
        printf "incomplete line - no newline"

        exit 3
      '';
      expectedBuilderExitCode = 3;
      expectedBuilderLogEntries = [
        "failing though"
        "also stderr"
        ''line\nwith-\bbackslashes''
        "incomplete line - no newline"
      ];
      script = ''
        grep --silent -F 'ok-ish' "$failed/result"
      '';
    };

    happyStructuredAttrs = overrideStructuredAttrs true final.happy;

    helloDoesNotFail = testers.testBuildFailure' {
      drv = testers.testBuildFailure hello;
      expectedBuilderLogEntries = [
        "testBuildFailure: The builder did not fail, but a failure was expected"
      ];
    };

    multiOutput = testers.testBuildFailure' {
      drv =
        runCommand "multiOutput"
          {
            # dev will be the default output
            outputs = [
              "dev"
              "doc"
              "out"
            ];
          }
          ''
            echo i am failing
            exit 1
          '';
      expectedBuilderLogEntries = [
        "i am failing"
      ];
      script = ''
        # Checking our note that dev is the default output
        echo $failed/_ | grep -- '-dev/_' >/dev/null
        echo 'All good.'
      '';
    };

    multiOutputStructuredAttrs = overrideStructuredAttrs true final.multiOutput;

    sideEffects = testers.testBuildFailure' {
      drv = stdenvNoCC.mkDerivation {
        name = "fail-with-side-effects";
        src = emptyDirectory;

        postHook = ''
          echo touching side-effect...
          # Assert that the side-effect doesn't exist yet...
          # We're checking that this hook isn't run by expect-failure.sh
          if [[ -e side-effect ]]; then
            echo "side-effect already exists"
            exit 1
          fi
          touch side-effect
        '';

        buildPhase = ''
          echo i am failing
          exit 1
        '';
      };
      expectedBuilderLogEntries = [
        "touching side-effect..."
        "i am failing"
      ];
      script = ''
        [[ ! -e side-effect ]]
      '';
    };

    sideEffectsStructuredAttrs = overrideStructuredAttrs true final.sideEffects;

    exitCodeNegativeTest = testers.testBuildFailure' {
      drv = testers.testBuildFailure' {
        drv = runCommand "exit-code" { } "exit 3";
        # Default expected exit code is 1
      };
      expectedBuilderLogEntries = [
        "ERROR: testBuilderExitCode: original builder produced exit code 3 but was expected to produce 1"
      ];
    };

    exitCodeNegativeTestStructuredAttrs = overrideStructuredAttrs true final.exitCodeNegativeTest;

    logNegativeTest = testers.testBuildFailure' {
      drv = testers.testBuildFailure' {
        drv = runCommand "exit-code" { } ''
          nixLog "apples"
          exit 3
        '';
        expectedBuilderExitCode = 3;
        expectedBuilderLogEntries = [ "bees" ];
      };
      expectedBuilderLogEntries = [
        "ERROR: testBuilderLogEntries: original builder log does not contain 'bees'"
      ];
    };

    logNegativeTestStructuredAttrs = overrideStructuredAttrs true final.logNegativeTest;
  };
in
recurseIntoAttrs final
