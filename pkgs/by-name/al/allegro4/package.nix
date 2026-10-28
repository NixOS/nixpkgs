{
  lib,
  stdenv,
  fetchurl,
  texinfo,
  libxext,
  xorgproto,
  libx11,
  libxpm,
  libxt,
  libxcursor,
  alsa-lib,
  cmake,
  pkg-config,
  zlib,
  libpng,
  libvorbis,
  libxxf86dga,
  libxxf86misc,
  libxxf86vm,
  openal,
  libGLU,
  libGL,
}:

stdenv.mkDerivation rec {
  pname = "allegro";
  version = "4.4.3.1";

  src = fetchurl {
    url = "https://github.com/liballeg/allegro5/releases/download/${version}/allegro-${version}.tar.gz";
    hash = "sha256-7BnbyaAhJEWCtIGbNYPuWUtQFB+fz2lEpO2Aacv41NQ=";
  };

  patches = [
    ./nix-unstable-sandbox-fix.patch
    ./encoding.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    texinfo
    libxext
    xorgproto
    libx11
    libxpm
    libxt
    libxcursor
    alsa-lib
    zlib
    libpng
    libvorbis
    libxxf86dga
    libxxf86misc
    libxxf86vm
    openal
    libGLU
    libGL
  ];

  hardeningDisable = [ "format" ];

  cmakeFlags = [
    "-DCMAKE_SKIP_RPATH=ON"
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
  ];

  meta = {
    description = "Game programming library";
    homepage = "https://liballeg.org/";
    license = lib.licenses.giftware;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
  };
}
