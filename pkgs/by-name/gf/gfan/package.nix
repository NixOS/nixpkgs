{
  lib,
  stdenv,
  fetchpatch,
  fetchurl,
  gmp,
  mpir,
  cddlib,
  onetbb,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gfan";
  version = "0.8beta";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://home.math.au.dk/jensen/software/gfan/gfan${finalAttrs.version}.tar.gz";
    hash = "sha256-+niE5fMXxQ+PtPN7z11Bnw/V97kNYDc0nRlX6nPOu+4=";
  };

  patches = [
    ./gfan-0.6.2-cddlib-prefix.patch
  ]
  ++ lib.optionals (stdenv.cc.isClang) [
    ./gfan-0.8beta-libcxx-threading.patch
    (fetchpatch {
      name = "clang-fix-miscompilation.patch";
      url = "https://raw.githubusercontent.com/sagemath/sage/eea1f59394a5066e9acd8ae39a90302820914ee3/build/pkgs/gfan/patches/nodel.patch";
      hash = "sha256-RrncSgFyrBIk/Bwe3accxiJ2rpOSJKQ84cV/uBvQsDc=";
    })
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail 'UNAME_S := $(shell uname -s)' 'UNAME_S := "nix"' \
      --replace-fail "-march=native" ""
  ''
  + lib.optionalString stdenv.cc.isClang ''
    substituteInPlace Makefile --replace-fail "-fno-guess-branch-probability" "" \
      --replace-fail "-finline-limit=1000" ""

    for f in $(find -name "*.h" -or -name "*.cpp"); do
        substituteInPlace "$f" --replace-quiet "log2" "_log2"
    done
  '';

  buildFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "CXX=${stdenv.cc.targetPrefix}c++"
  ];
  installFlags = [ "PREFIX=$(out)" ];
  buildInputs = [
    gmp
    mpir
    cddlib
    onetbb
  ];
  enableParallelBuilding = true;
  hardeningDisable = [ "libcxxhardeningfast" ];

  doCheck = true;
  # The test runner still exits successfully when there are failed tests, so check
  # stdout to see if anything failed.
  checkPhase = ''
    runHook preCheck
    make check | tee "$TMPDIR/test.log"
    ! grep -q "Failed tests:" "$TMPDIR/test.log"
    runHook postCheck
  '';

  meta = {
    description = "Software package for computing Gröbner fans and tropical varieties";
    license =
      with lib.licenses;
      OR [
        gpl2Only
        gpl3Only
      ];
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.unix;
    homepage = "http://home.math.au.dk/jensen/software/gfan/gfan.html";
  };
})
