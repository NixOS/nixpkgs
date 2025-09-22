# Run:
#   nix-build -A tests.testers.shellcheck

{
  lib,
  testers,
}:
lib.recurseIntoAttrs {
  example-dir = testers.testBuildFailure' {
    drv = testers.shellcheck {
      name = "example-dir";
      src = ./src;
    };
    expectedBuilderExitCode = 123;
    expectedBuilderLogEntries = [
      ''
        echo $@
             ^-- SC2068 (error): Double quote array expansions to avoid re-splitting elements.
      ''
    ];
  };

  example-file = testers.testBuildFailure' {
    drv = testers.shellcheck {
      name = "example-file";
      src = ./src/example.sh;
    };
    expectedBuilderExitCode = 123;
    expectedBuilderLogEntries = [
      ''
        echo $@
             ^-- SC2068 (error): Double quote array expansions to avoid re-splitting elements.
      ''
    ];
  };
}
