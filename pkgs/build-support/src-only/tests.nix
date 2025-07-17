{
  lib,
  runCommand,
  srcOnly,
  hello,
  emptyDirectory,
  zlib,
  git,
  withCFlags,
  stdenv,
  testers,
}:

let
  # Extract (effective) arguments passed to stdenv.mkDerivation and compute the
  # arguments we would need to pass to srcOnly manually in order to get the same
  # as `srcOnly drv`, i.e. the arguments passed to stdenv.mkDerivation plus the
  # used stdenv itself.
  getEquivAttrs =
    drv:
    let
      drv' = drv.overrideAttrs (
        _finalAttrs: prevAttrs: {
          passthru = prevAttrs.passthru or { } // {
            passedAttrs = prevAttrs;
          };
        }
      );
    in
    drv'.passedAttrs // { inherit (drv') stdenv; };

  canEvalDrv = drv: (builtins.tryEval drv.drvPath).success;

  emptySrc = srcOnly emptyDirectory;
  zlibSrc = srcOnly zlib;

  # It can be invoked in a number of ways. Let's make sure they're equivalent.
  zlibSrcEquiv = srcOnly (getEquivAttrs zlib);
  # zlibSrcFreeform = # ???;
  helloSrc = srcOnly hello;
  helloSrcEquiv = srcOnly (getEquivAttrs hello);

  gitSrc = srcOnly git;
  gitSrcEquiv = srcOnly (getEquivAttrs git);

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
  helloDrvSimpleSrcFreeform = srcOnly ({
    inherit (helloDrvSimple)
      name
      pname
      version
      src
      patches
      stdenv
      ;
  });

  # Test the issue reported in https://github.com/NixOS/nixpkgs/issues/269539
  stdenvAdapterDrv =
    let
      drv = (withCFlags [ "-Werror" "-Wall" ] stdenv).mkDerivation {
        name = "drv-using-stdenv-adapter";
      };
    in
    # Confirm the issue we are trying to avoid exists
    assert !(canEvalDrv (srcOnly drv.drvAttrs));
    drv;
  stdenvAdapterDrvSrc = srcOnly stdenvAdapterDrv;
  stdenvAdapterDrvSrcEquiv = srcOnly (
    getEquivAttrs stdenvAdapterDrv
    // {
      # The upside of using overrideAttrs is that any stdenv adapter related
      # modifications are only applied once. Using the adapter here again would
      # mean applying it twice in total (since withCFlags functions more or less
      # like an automatic overrideAttrs).
      inherit stdenv;
    }
  );

  # Issue similar to https://github.com/NixOS/nixpkgs/issues/269539
  structuredAttrsDrv =
    let
      drv = stdenv.mkDerivation {
        name = "drv-using-structured-attrs";
        src = emptyDirectory;

        env.NIX_DEBUG = true;
        __structuredAttrs = true;
      };
    in
    # Confirm the issue we are trying to avoid exists
    assert !(canEvalDrv (srcOnly drv.drvAttrs));
    drv;
  structuredAttrsDrvSrc = srcOnly structuredAttrsDrv;
  structuredAttrsDrvSrcEquiv = srcOnly (getEquivAttrs structuredAttrsDrv);

in

runCommand "srcOnly-tests"
  {
    moreTests = [
      (testers.testEqualDerivation "zlibSrcEquiv == zlibSrc" zlibSrcEquiv zlibSrc)
      # (testers.testEqualDerivation
      #   "zlibSrcFreeform == zlibSrc"
      #   zlibSrcFreeform
      #   zlibSrc)
      (testers.testEqualDerivation "helloSrcEquiv == helloSrc" helloSrcEquiv helloSrc)
      (testers.testEqualDerivation "helloSrcEquiv == helloSrc" helloSrcEquiv helloSrc)
      (testers.testEqualDerivation "gitSrcEquiv == gitSrc" gitSrcEquiv gitSrc)
      (testers.testEqualDerivation "helloDrvSimpleSrcFreeform == helloDrvSimpleSrc"
        helloDrvSimpleSrcFreeform
        helloDrvSimpleSrc
      )
      (testers.testEqualDerivation "stdenvAdapterDrvSrcEquiv == stdenvAdapterDrvSrc"
        stdenvAdapterDrvSrcEquiv
        stdenvAdapterDrvSrc
      )
      (testers.testEqualDerivation "structuredAttrsDrvSrcEquiv == structuredAttrsDrvSrc"
        structuredAttrsDrvSrcEquiv
        structuredAttrsDrvSrc
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
