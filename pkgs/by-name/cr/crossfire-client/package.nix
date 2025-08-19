{
  stdenv,
  lib,
  fetchgit,
  cmake,
  pkg-config,
  perl,
  vala,
  gtk2,
  pcre,
  zlib,
  libGL,
  libGLU,
  libpng,
  fribidi,
  harfbuzzFull,
  xorg,
  util-linux,
  curl,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  libselinux,
  libsepol,
}:

stdenv.mkDerivation {
  pname = "crossfire-client";
  version = "2025-01";

  src = fetchgit {
    url = "https://git.code.sf.net/p/crossfire/crossfire-client";
    hash = "sha256-iFm9yVEIBwngr8/0f9TRS4Uw0hnjrW6ngMRfsWY6TX0=";
    rev = "c69f578add358c1db567f6b46f532dd038d2ade0";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    perl
    vala
  ];
  buildInputs = [
    gtk2
    pcre
    zlib
    libGL
    libGLU
    libpng
    fribidi
    harfbuzzFull
    xorg.libpthreadstubs
    xorg.libXdmcp
    curl
    SDL2
    SDL2_image
    SDL2_mixer
    util-linux
    libselinux
    libsepol
  ];
  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "GTKv2 client for the Crossfire free MMORPG";
    mainProgram = "crossfire-client-gtk2";
    homepage = "http://crossfire.real-time.com/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ToxicFrog ];
  };
}
