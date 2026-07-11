{
  runCommand,
  breseq,
}:

let
  inherit (breseq) pname version;
in

runCommand "breseq-tests" { meta.timeout = 60; } ''
  echo "Testing breseq - gdtools executable"
  export TESTBINPREFIX=${breseq}/bin
  cp ${breseq}/tests $PWD/breseqtests -r
  chmod -R +w $PWD/breseqtests
  output=$($PWD/breseqtests/gdtools_compare_1/testcmd.sh 2>&1) || {
    echo "$output"
    echo "Error testing breseq - gdtools executable"
    exit 1
  }
  touch $out
''
