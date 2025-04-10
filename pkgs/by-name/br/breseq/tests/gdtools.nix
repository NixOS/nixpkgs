{
  runCommand,
  phoronix-test-suite,
  breseq,
}:

let
  inherit (phoronix-test-suite) pname version;
in

runCommand "${pname}-tests" { meta.timeout = 60; } ''
  ${phoronix-test-suite}/bin/phoronix-test-suite enterprise-setup >/dev/null
  if [[ `${phoronix-test-suite}/bin/phoronix-test-suite version` != *"${version}"*  ]]; then
    echo "Error: program version does not match package version"
    exit 1
  fi

  export TESTBINPREFIX=${breseq}/bin
  export TESTDIR=$(mktemp -d)
  trap "rm -rf \"$TESTDIR\"" EXIT
  cp ${breseq}/tests $TESTDIR/breseqtests -r
  chmod -R +w $TESTDIR/breseqtests
  echo "Testing breseq - gdtools executable"
  output=$($TESTDIR/breseqtests/gdtools_compare_1/testcmd.sh 2>&1) || {
    echo "$output"
    echo "Error testing breseq - gdtools executable"
    exit 1
  }
  touch $out
''
