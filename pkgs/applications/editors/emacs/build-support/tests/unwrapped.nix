{
  runCommand,
  emacs,
  writeShellApplication,
}:

let
  run-test = writeShellApplication {
    name = "run-test";
    runtimeInputs = [
      emacs
    ];
    runtimeEnv = {
      EMACS_TEST_VERBOSE = 1; # make ERT output verbose
    };
    text = ''
      emacs --batch \
        --load=${./with-packages.el} \
        --eval="(ert-run-tests-batch-and-exit '(tag :shared-with-unwrapped))"
    '';
  };
in
runCommand "test-emacs-unwrapped"
  {
    nativeBuildInputs = [
      run-test
    ];
  }
  ''
    run-test

    touch $out
  ''
