{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "coinmp";
  version = "1.8.4";

  src = fetchurl {
    url = "https://www.coin-or.org/download/source/CoinMP/CoinMP-${finalAttrs.version}.tgz";
    hash = "sha256-NFn7DMvdOTQnRGhDOJhKxMwVP7BDT0yujPdL1nSQo40=";
  };

  patches = [
    # backport build fixes for pkgsMusl.CoinMP
    (fetchpatch {
      url = "https://github.com/coin-or/Cgl/commit/57d8c71cd50dc27a89eaeb4672499bca55f1fd72.patch";
      extraPrefix = "Cgl/";
      stripLen = 1;
      hash = "sha256-NdwXpIL1w6kHVfhBFscTlpriQOfUXx860/4x7pK+698=";
    })
    # https://github.com/coin-or/Clp/commit/b637e1d633425ae21ec041bf7f9e06f56b741de0
    ./0001-change-more-reinterpret_cast-from-NULL-to-C-cast-see.patch
    # https://github.com/coin-or/Clp/commit/e749fe6b11a90006d744af2ca2691220862e3a59
    ./0002-change-reinterpret_cast-of-NULL-to-C-style-case-fixe.patch
    # https://github.com/coin-or/Cbc/commit/584fd12fba6a562d49864f44bedd13ee32d06999
    ./0001-use-static_cast-for-static-cast-fixes-319.patch
  ];

  enableParallelBuilding = true;

  env = lib.optionalAttrs stdenv.cc.isClang {
    CXXFLAGS = "-std=c++14";
  };

  hardeningDisable = [ "format" ];

  meta = with lib; {
    homepage = "https://projects.coin-or.org/CoinMP/";
    description = "COIN-OR lightweight API for COIN-OR libraries CLP, CBC, and CGL";
    platforms = platforms.unix;
    license = licenses.epl10;
  };
})
