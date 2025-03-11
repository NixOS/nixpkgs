{
  lib,
  stdenv,
  fetchurl,
  m4,
  which,
  yasm,
  autoreconfHook,
  fetchpatch,
  buildPackages,
}:

stdenv.mkDerivation rec {
  pname = "mpir";
  version = "3.0.0";

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [
    m4
    which
    yasm
    autoreconfHook
  ];

  src = fetchurl {
    url = "https://mpir.org/mpir-${version}.tar.bz2";
    sha256 = "1fvmhrqdjs925hzr2i8bszm50h00gwsh17p2kn2pi51zrxck9xjj";
  };

  patches = [
    # Fixes configure check failures with clang 16 due to implicit definitions of `exit`, which
    # is an error with newer versions of clang.
    (fetchpatch {
      url = "https://github.com/wbhart/mpir/commit/bbc43ca6ae0bec4f64e69c9cd4c967005d6470eb.patch";
      hash = "sha256-vW+cDK5Hq2hKEyprOJaNbj0bT2FJmMcyZHPE8GUNUWc=";
    })
    # https://github.com/wbhart/mpir/pull/299
    (fetchpatch {
      name = "gcc-14-fixes.patch";
      url = "https://github.com/wbhart/mpir/commit/4ff3b770cbf86e29b75d12c13e8b854c74bccc5a.patch";
      hash = "sha256-dCB2+1IYTGzHUQkDUF4gqvR1xoMPEYVPLGE+EP2wLL4=";
    })
  ];

  configureFlags = [ "--enable-cxx" ] ++ lib.optionals stdenv.hostPlatform.isLinux [ "--enable-fat" ];

  meta = {
    description = "Highly optimised library for bignum arithmetic forked from GMP";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.unix;
    downloadPage = "https://mpir.org/downloads.html";
    homepage = "https://mpir.org/";
  };
}
