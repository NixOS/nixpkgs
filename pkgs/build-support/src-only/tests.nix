{
  runCommand,
  srcOnly,
  hello,
  emptyDirectory,
  zlib,
  stdenv,
  testers,
}:

let
  emptySrc = srcOnly emptyDirectory;
  zlibSrc = srcOnly zlib;

  # It can be invoked in a number of ways. Let's make sure they're equivalent.
  zlibSrcDrvAttrs = srcOnly zlib.drvAttrs;
  # zlibSrcFreeform = # ???;
  helloSrc = srcOnly hello;
  helloSrcDrvAttrs = srcOnly hello.drvAttrs;

  # The srcOnly <drv> invocation leaks a lot of attrs into the srcOnly derivation,
  # so for comparing with the freeform invocation, we need to make a selection.
  # Otherwise, we'll be comparing against whatever attribute the fancy hello drv
  # has.
  helloDrvSimple = stdenv.mkDerivation {
    inherit (hello)
      name
      pname
      version
      src
      patches
      ;
  };
  helloDrvSimpleSrc = srcOnly helloDrvSimple;
  helloDrvSimpleSrcFreeform = srcOnly {
    inherit (helloDrvSimple)
      name
      pname
      version
      src
      patches
      stdenv
      ;
  };

in

runCommand "srcOnly-tests"
  {
    moreTests = [
      (testers.testEqualDerivation "zlibSrcDrvAttrs == zlibSrc" zlibSrcDrvAttrs zlibSrc)
      # (testers.testEqualDerivation
      #   "zlibSrcFreeform == zlibSrc"
      #   zlibSrcFreeform
      #   zlibSrc)
      (testers.testEqualDerivation "helloSrcDrvAttrs == helloSrc" helloSrcDrvAttrs helloSrc)
      (testers.testEqualDerivation "helloDrvSimpleSrcFreeform == helloDrvSimpleSrc"
        helloDrvSimpleSrcFreeform
        helloDrvSimpleSrc
      )
    ];
  }
  ''
    # Test that emptySrc is empty
    if [ -n "$(ls -A ${emptySrc})" ]; then
      echo "emptySrc is not empty"
      exit 1
    fi

    # Test that zlibSrc is not empty
    if [ -z "$(ls -A ${zlibSrc})" ]; then
      echo "zlibSrc is empty"
      exit 1
    fi

    # Make $out exist to avoid build failure
    mkdir -p $out
  ''
