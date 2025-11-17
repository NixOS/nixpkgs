{ runCommand, hello }:

runCommand "hello-test-run"
  {
    nativeBuildInputs = [ hello ];
  }
  ''
    diff -U3 --color=auto <(hello) <(echo 'Hello, world!')
    touch $out
  ''
