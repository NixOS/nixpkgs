{ runCommand, kiesel }:
runCommand "kiesel-test-run"
  {
    nativeBuildInputs = [ kiesel ];
  }
  ''
    export NO_COLOR=1
    GOT=$(kiesel -p -c 'Array(16).join("wat" - 1) + " Batman!"')
    EXPECT='"NaNNaNNaNNaNNaNNaNNaNNaNNaNNaNNaNNaNNaNNaNNaN Batman!"'
    test "$EXPECT" = "$GOT"
    touch $out
  ''
