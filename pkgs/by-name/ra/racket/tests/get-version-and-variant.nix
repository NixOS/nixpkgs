{
  lib,
  runCommandLocal,
  racket,
}:

runCommandLocal "racket-test-get-version-and-variant"
  {
    nativeBuildInputs = [ racket ];
  }
  (
    lib.concatLines (
      builtins.map
        (
          { expectation, output }:
          ''
            expectation="${expectation}"

            output="${output}"

            if test "$output" != "$expectation"; then
                echo "output mismatch: expected ''${expectation}, but got ''${output}"
                exit 1
            fi
          ''
        )
        [
          {
            expectation = racket.version;
            output = "$(racket -e '(display (version))')";
          }
          {
            expectation = "cs";
            output = "$(racket -e '(require launcher/launcher) (display (current-launcher-variant))')";
          }
          {
            expectation = "${lib.getExe racket}";
            output = "$(racket -e '(require compiler/find-exe) (display (find-exe))')";
          }
        ]
    )
    + ''
      touch $out
    ''
  )
