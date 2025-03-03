# Run:
#   nix-build -A tests.testers.shellcheck

{
  lib,
  testers,
  runCommand,
}:
lib.recurseIntoAttrs {

  example-dir =
    runCommand "test-testers-shellcheck-example-dir"
      {
        failure = testers.testBuildFailure (
          testers.shellcheck {
            name = "shellcheck-example-dir";
            src = ./src;
          }
        );
      }
      ''
        log="$failure/testBuildFailure.log"
        echo "Checking $log"
        grep SC2068 "$log"
        touch $out
      '';

  example-file =
    runCommand "test-testers-shellcheck-example-file"
      {
        failure = testers.testBuildFailure (
          testers.shellcheck {
            name = "shellcheck-example-file";
            src = ./src/example.sh;
          }
        );
      }
      ''
        log="$failure/testBuildFailure.log"
        echo "Checking $log"
        grep SC2068 "$log"
        touch $out
      '';
}
