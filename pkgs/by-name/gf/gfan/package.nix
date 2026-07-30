{
  lib,
  stdenv,
  fetchpatch,
  fetchurl,
  gmp,
  mpir,
  cddlib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gfan";
  version = "0.7";

  src = fetchurl {
    url = "https://home.math.au.dk/jensen/software/gfan/gfan${finalAttrs.version}.tar.gz";
    sha256 = "sha256-q4M3V+Hk1KmGYvSqaROUAT6poib2QWuPhWU1bW/MmJ4=";
  };

  patches = [
    ./gfan-0.6.2-cddlib-prefix.patch
    (fetchpatch {
      name = "cstdint.patch";
      url = "https://salsa.debian.org/math-team/gfan/-/raw/6bb6bc3dd517b3c26fbcb76bfdc47f04d1978007/debian/patches/cstdint.patch";
      hash = "sha256-ALD8Exe2SW8TZg0hIfhvUuiEbbT3Sk7v+oLnNsYA8hs=";
    })
  ]
  ++ lib.optionals (stdenv.cc.isClang) [
    (fetchpatch {
      name = "clang-fix-miscompilation.patch";
      url = "https://raw.githubusercontent.com/sagemath/sage/eea1f59394a5066e9acd8ae39a90302820914ee3/build/pkgs/gfan/patches/nodel.patch";
      sha256 = "sha256-RrncSgFyrBIk/Bwe3accxiJ2rpOSJKQ84cV/uBvQsDc=";
    })
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
    # On MacOS, we need to adress differences in int64_t types and remove the
    # "experimental/" library and namespace prefixes as well as references to
    # std::execution.
    ./gfan-0.7-macos.patch
  ];

  postPatch = lib.optionalString stdenv.cc.isClang ''
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
  ];
  enableParallelBuilding = true;
  hardeningDisable = [ "libcxxhardeningfast" ];

  doCheck = true;
  # The test runner still exits successfully when there are failed tests, so check
  # stdout to see if anything failed.
  checkPhase = ''
    make check | tee "$TMPDIR/test.log"
    ! grep -q "Failed tests:" "$TMPDIR/test.log"
  '';

  meta = {
    description = "Software package for computing Gröbner fans and tropical varieties";
    license =
      with lib.licenses;
      OR [
        gpl2
        gpl3
      ];
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.unix;
    homepage = "http://home.math.au.dk/jensen/software/gfan/gfan.html";
  };
})
