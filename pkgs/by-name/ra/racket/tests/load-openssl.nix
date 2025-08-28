{ runCommandLocal, racket }:

runCommandLocal "racket-test-load-openssl"
  {
    nativeBuildInputs = [ racket ];
  }
  ''
    racket -f - <<EOF
    (require openssl)
    (unless ssl-available?
      (raise ssl-load-fail-reason))
    EOF

    touch $out
  ''
