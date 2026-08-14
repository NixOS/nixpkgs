{ runCommandLocal, racket }:

runCommandLocal "racket-test-write-greeting"
  {
    nativeBuildInputs = [ racket ];
  }
  ''
    expectation="Hello, world!"

    racket -f - <<EOF
    (with-output-to-file (getenv "out")
      (lambda ()
        (display "Hello, world!")
        (newline)))
    EOF

    output="$(cat $out)"

    if test "$output" != "$expectation"; then
        echo "output mismatch: expected ''${expectation}, but got ''${output}"
        exit 1
    fi
  ''
