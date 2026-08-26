{ runCommandLocal, racket }:

let
  script = racket.writeScript "racket-test-nix-write-script-the-script" { } ''
    #lang racket/base
    (display "success")
    (newline)
  '';
in

runCommandLocal "racket-test-nix-write-script"
  {
    nativeBuildInputs = [ racket ];
  }
  ''
    expectation="success"

    output="$(${script})"

    if test "$output" != "$expectation"; then
        echo "output mismatch: expected ''${expectation}, but got ''${output}"
        exit 1
    fi

    touch $out
  ''
