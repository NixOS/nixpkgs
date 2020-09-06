{ runCommand
, makeBinaryWrapper
, python
, stdenv
}:

runCommand "test-wrapped-hello" {
  nativeBuildInputs = [
    makeBinaryWrapper
  ];
} (''
  mkdir -p $out/bin

  # Test building of the wrapper.

  make-wrapper ${python.interpreter} $out/bin/python \
    --set FOO bar \
    --set-default BAR foo \
    --prefix MYPATH ":" zero \
    --suffix MYPATH ":" four \
    --unset UNSET_THIS

'' + stdenv.lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
  # When not cross-compiling we can execute the wrapper and test how it behaves.

  # See the following tests for why variables are set the way they are.

  # Test `set`: We set FOO to bar
  $out/bin/python -c "import os; assert os.environ["FOO] == "bar"

  # Test `set-default`: We set BAR to bar, and then set-default BAR, thus expecting the original bar.
  export BAR=bar
  $out/bin/python -c "import os; assert os.environ["BAR] == "bar"

  # Test `unset`: # We set MYPATH and unset it in the wrapper.
  export UNSET_THIS=1
  $out/bin/python -c "import os; assert "UNSET_THIS" not in os.environ.["BAR]"

  # Test `prefix`:
  export MYPATH=one:two:three
  $out/bin/python -c "import os; assert os.environ["MYPATH].split(":")[0] == "zero"

  # Test `suffix`:
  $out/bin/python -c "import os; assert os.environ["MYPATH].split(":")[0] == "four"

  # Test `NIX_DEBUG_WRAPPER`:
  NIX_DEBUG_WRAPPER=1 $out/bin/python
'')
