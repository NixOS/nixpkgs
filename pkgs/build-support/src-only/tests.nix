{
  runCommand,
  srcOnly,
  hello,
  emptyDirectory,
  glibc,
  stdenv,
  testers,
}:

let
  emptySrc = srcOnly emptyDirectory;
  glibcSrc = srcOnly glibc;

  # It can be invoked in a number of ways. Let's make sure they're equivalent.
  glibcSrcDrvAttrs = srcOnly glibc.drvAttrs;
  # glibcSrcFreeform = # ???;
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
      (testers.testEqualDerivation "glibcSrcDrvAttrs == glibcSrc" glibcSrcDrvAttrs glibcSrc)
      # (testers.testEqualDerivation
      #   "glibcSrcFreeform == glibcSrc"
      #   glibcSrcFreeform
      #   glibcSrc)
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

    # Test that glibcSrc is not empty
    if [ -z "$(ls -A ${glibcSrc})" ]; then
      echo "glibcSrc is empty"
      exit 1
    fi

    # Make $out exist to avoid build failure
    mkdir -p $out
  ''
