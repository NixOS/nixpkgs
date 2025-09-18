{
  lib,
  stdenv,
  fetchpatch,
  fetchurl,
  gmp,
  mpir,
  cddlib,
}:
stdenv.mkDerivation rec {
  pname = "gfan";
  version = "0.6.2";

  src = fetchurl {
    url = "http://home.math.au.dk/jensen/software/gfan/gfan${version}.tar.gz";
    sha256 = "02pihqb1lb76a0xbfwjzs1cd6ay3ldfxsm8dvsbl6qs3vkjxax56";
  };

  patches = [
    ./gfan-0.6.2-cddlib-prefix.patch
    (fetchpatch {
      # removes dead code with invalid member reference in gfanlib
      name = "clang-19.patch";
      url = "https://github.com/Singular/Singular/commit/d3f73432d73ac0dd041af83cb35301498e9b57d9.patch";
      stripLen = 2;
      extraPrefix = "src/";
      hash = "sha256-jPGMYx/GOFV7Tk3CqaRWeX/UHkzjeL57eZj4r40s8/g=";
    })
  ]
  ++ lib.optionals (stdenv.cc.isClang) [
    (fetchpatch {
      name = "clang-fix-miscompilation.patch";
      url = "https://raw.githubusercontent.com/sagemath/sage/eea1f59394a5066e9acd8ae39a90302820914ee3/build/pkgs/gfan/patches/nodel.patch";
      sha256 = "sha256-RrncSgFyrBIk/Bwe3accxiJ2rpOSJKQ84cV/uBvQsDc=";
    })
  ];

  postPatch = lib.optionalString stdenv.cc.isClang ''
    substituteInPlace Makefile --replace "-fno-guess-branch-probability" ""

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

  meta = {
    description = "Software package for computing Gröbner fans and tropical varieties";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.unix;
    homepage = "http://home.math.au.dk/jensen/software/gfan/gfan.html";
  };
}
