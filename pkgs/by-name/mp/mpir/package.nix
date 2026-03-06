{
  lib,
  stdenv,
  fetchFromGitHub,
  m4,
  which,
  yasm,
  texinfo,
  autoreconfHook,
  fetchpatch,
  buildPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mpir";
  version = "3.0.0";

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [
    m4
    which
    yasm
    texinfo
    autoreconfHook
  ];

  src = fetchFromGitHub {
    owner = "wbhart";
    repo = "mpir";
    tag = "mpir-${finalAttrs.version}";
    hash = "sha256-Q5P3N2w6NX+s5Fu3obTDOg+tEAWnAMDgbRlzFTpolmg=";
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
    (fetchpatch {
      url = "https://gitlab.alpinelinux.org/alpine/aports/-/raw/a67361db03777a80446ffa8e512f26edb299268f/community/mpir/gcc15.patch";
      hash = "sha256-8RqMHYqDowHytgBd4RsGEOLkk+spYS+iqWQL2kzGAtI=";
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
})
