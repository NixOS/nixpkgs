{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ncompress";
  version = "5.0";

  src = fetchFromGitHub {
    owner = "vapier";
    repo = "ncompress";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Yhs3C5/kR7Ve56E84usYJprxIMAIwXVahLi1N9TIfj0=";
  };

  patches = [
    # dependencies for gcc15 patch
    (fetchpatch {
      url = "https://github.com/vapier/ncompress/commit/af7d29d87ddf8b2002dad41152efa94e9c825b35.patch";
      excludes = [ "Changes" ];
      hash = "sha256-zc+59RHVt5/aw5a4OVnOmXyFdeoshqbARG2upDujEk4=";
    })
    (fetchpatch {
      url = "https://github.com/vapier/ncompress/commit/aa359df10ec29a56c12f6e5c2bcec8d8ecfa2740.patch";
      excludes = [ "Changes" ];
      hash = "sha256-wtZJBSfJ6QmYK+ywijQ263PnjGwD2mXcvFWvBNeODpc=";
    })
    # fix build against gcc15
    # https://github.com/vapier/ncompress/pull/40
    (fetchpatch {
      url = "https://github.com/vapier/ncompress/pull/40/commits/90810a7f11bf157b479c23c0fe6cee0bebec15c6.patch";
      hash = "sha256-aqIofwTxlg2lq2+ZBhG6X6MKUoafHrADZlw7Avj8anQ=";
    })
  ];

  makeFlags = [ "PREFIX=$(out)" ];
  installTargets = "install_core";

  postInstall = ''
    mv $out/bin/uncompress $out/bin/uncompress-ncompress
  '';

  meta = {
    homepage = "https://vapier.github.io/ncompress/";
    license = lib.licenses.publicDomain;
    description = "Fast, simple LZW file compressor";
    platforms = lib.platforms.unix;
  };
})
