{
  lib,
  stdenv,
  fetchzip,
  fetchpatch,
  zlib,
  zopfli,
}:

stdenv.mkDerivation rec {
  pname = "gif2apng";
  version = "1.9";

  src = fetchzip {
    url = "mirror://sourceforge/gif2apng/gif2apng-${version}-src.zip";
    stripRoot = false;
    hash = "sha256-rt1Vp4hjeFAVWJOU04BdU2YvBwECe9Q1c7EpNpIN+uE=";
  };

  patches = [
    (fetchpatch {
      url = "https://sources.debian.org/data/main/g/gif2apng/1.9%2Bsrconly-3%2Bdeb11u1/debian/patches/10-7z.patch";
      hash = "sha256-zQgSWP/CIGaTUIxP/X92zpAQVSGgVo8gQEoCCMn+XT0=";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/g/gif2apng/1.9%2Bsrconly-3%2Bdeb11u1/debian/patches/CVE-2021-45909.patch";
      hash = "sha256-ZDN3xgvktgahDEtrEpyVsL+4u+97Fo9vAB1RSKhu8KA=";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/g/gif2apng/1.9%2Bsrconly-3%2Bdeb11u1/debian/patches/CVE-2021-45910.patch";
      hash = "sha256-MzOUOC7kqH22DmTMXoDu+jZAMBJPndnFNJGAQv5FcdI=";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/g/gif2apng/1.9%2Bsrconly-3%2Bdeb11u1/debian/patches/CVE-2021-45911.patch";
      hash = "sha256-o2YDHsSaorCx/6bQQfudzkLHo9pakgyvs2Pbafplnek=";
    })
  ];

  # Remove bundled libs
  postPatch = ''
    rm -r 7z zlib zopfli
  '';

  buildInputs = [
    zlib
    zopfli
  ];

  preBuild = ''
    buildFlagsArray+=("LIBS=-lzopfli -lstdc++ -lz")
  '';

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}c++" ];

  NIX_CFLAGS_COMPILE = "-DENABLE_LOCAL_ZOPFLI";

  installPhase = ''
    runHook preInstall
    install -Dm755 gif2apng $out/bin/gif2apng
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://gif2apng.sourceforge.net/";
    description = "Simple program that converts animations from GIF to APNG format";
    license = licenses.zlib;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
}
