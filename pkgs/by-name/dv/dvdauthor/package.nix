{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  libdvdread,
  libxml2,
  freetype,
  fribidi,
  libpng,
  zlib,
  pkg-config,
  flex,
  bison,
}:

stdenv.mkDerivation rec {
  pname = "dvdauthor";
  version = "0.7.2";

  src = fetchurl {
    url = "mirror://sourceforge/dvdauthor/dvdauthor-${version}.tar.gz";
    hash = "sha256-MCCpLen3jrNvSLbyLVoAHEcQeCZjSnhaYt/NCA9hLrc=";
  };

  buildInputs = [
    libpng
    freetype
    libdvdread
    libxml2
    zlib
    fribidi
    flex
    bison
  ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    libxml2 # xml2-config (only checked for, not used)
  ];

  # set *-config for cross builds
  configureFlags = [
    "FREETYPECONFIG=${lib.getExe' (lib.getDev freetype) "freetype-config"}"
    "XML2_CONFIG=${lib.getExe' (lib.getDev libxml2) "xml2-config"}"
  ];

  meta = with lib; {
    description = "Tools for generating DVD files to be played on standalone DVD players";
    homepage = "https://dvdauthor.sourceforge.net/"; # or https://github.com/ldo/dvdauthor
    license = licenses.gpl2;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
