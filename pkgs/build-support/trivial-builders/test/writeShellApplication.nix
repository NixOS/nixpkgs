# Run with:
# nix-build -A tests.trivial-builders.writeShellApplication
{
  writeShellApplication,
  writeTextFile,
  runCommand,
  lib,
  linkFarm,
  diffutils,
  hello,
}:
let
  checkShellApplication =
    args@{ name, expected, ... }:
    let
      writeShellApplicationArgs = builtins.removeAttrs args [ "expected" ];
      script = writeShellApplication writeShellApplicationArgs;
      executable = lib.getExe script;
      expected' = writeTextFile {
        name = "${name}-expected";
        text = expected;
      };
      actual = "${name}-actual";
    in
    runCommand name { } ''
      echo "Running test executable ${name}"
      ${executable} > ${actual}
      echo "Got output from test executable:"
      cat ${actual}
      echo "Checking test output against expected output:"
      ${diffutils}/bin/diff --color --unified ${expected'} ${actual}
      touch $out
    '';
in
linkFarm "writeShellApplication-tests" {
  test-meta =
    let
      script = writeShellApplication {
        name = "test-meta";
        text = "";
        meta.description = "Test for the `writeShellApplication` `meta` argument";
      };
    in
    assert script.meta.mainProgram == "test-meta";
    assert script.meta.description == "A test for the `writeShellApplication` `meta` argument";
    script;

  test-runtime-inputs = checkShellApplication {
    name = "test-runtime-inputs";
    text = ''
      hello
    '';
    runtimeInputs = [ hello ];
    expected = "Hello, world!\n";
  };

  test-runtime-env = checkShellApplication {
    name = "test-runtime-env";
    runtimeEnv = {
      MY_COOL_ENV_VAR = "my-cool-env-value";
      MY_OTHER_COOL_ENV_VAR = "my-other-cool-env-value";
      # Check that we can serialize a bunch of different types:
      BOOL = true;
      INT = 1;
      LIST = [
        1
        2
        3
      ];
      MAP = {
        a = "a";
        b = "b";
      };
    };
    text = ''
      echo "$MY_COOL_ENV_VAR"
      echo "$MY_OTHER_COOL_ENV_VAR"
    '';
    expected = ''
      my-cool-env-value
      my-other-cool-env-value
    '';
  };

  test-check-phase = checkShellApplication {
    name = "test-check-phase";
    text = "";
    checkPhase = ''
      echo "echo -n hello" > $target
    '';
    expected = "hello";
  };

  test-argument-forwarding = checkShellApplication {
    name = "test-argument-forwarding";
    text = "";
    derivationArgs.MY_BUILD_TIME_VARIABLE = "puppy";
    derivationArgs.postCheck = ''
      if [[ "$MY_BUILD_TIME_VARIABLE" != puppy ]]; then
        echo "\$MY_BUILD_TIME_VARIABLE is not set to 'puppy'!"
        exit 1
      fi
    '';
    meta.description = "Test checking that `writeShellApplication` forwards extra arguments to `stdenv.mkDerivation`";
    expected = "";
  };

  test-exclude-shell-checks = writeShellApplication {
    name = "test-exclude-shell-checks";
    excludeShellChecks = [ "SC2016" ];
    text = ''
      # Triggers SC2016: Expressions don't expand in single quotes, use double
      # quotes for that.
      echo '$SHELL'
    '';
  };

  test-bash-options-pipefail = checkShellApplication {
    name = "test-bash-options-pipefail";
    text = ''
      touch my-test-file
      echo puppy | grep doggy | sed 's/doggy/puppy/g'
      #            ^^^^^^^^^^ This will fail.
      true
    '';
    # Don't use `pipefail`:
    bashOptions = [
      "errexit"
      "nounset"
    ];
    expected = "";
  };

  test-bash-options-nounset = checkShellApplication {
    name = "test-bash-options-nounset";
    text = ''
      echo -n "$someUndefinedVariable"
    '';
    # Don't use `nounset`:
    bashOptions = [ ];
    # Don't warn about the undefined variable at build time:
    excludeShellChecks = [ "SC2154" ];
    expected = "";
  };

}
