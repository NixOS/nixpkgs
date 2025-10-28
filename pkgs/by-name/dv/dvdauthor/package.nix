{
  lib,
  stdenv,
  fetchpatch2,
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

  patches = [
    (fetchpatch2 {
      # remove after next release: "Use pkg-config to find FreeType"
      url = "https://github.com/ldo/dvdauthor/commit/d5bb0bdd542c33214855a7062fcc485f8977934e.patch?full_index=1";
      hash = "sha256-cCj1Wkc6dZvUpjentpK68Q92tb7h+OXwrqdhJ2KYMvU=";
    })
    (fetchpatch2 {
      # remove after next release: "fix to build with GraphicsMagick" (required for subsequent patches to apply)
      url = "https://github.com/ldo/dvdauthor/commit/84d971def13b7e6317eae44369f49fd709b01030.patch?full_index=1";
      hash = "sha256-SWgbaS4cdvrXJ4H5KDM0S46H57rji7CX4Fkfa/RSSPA=";
    })
    (fetchpatch2 {
      # remove after next release: "Use PKG_CHECK_MODULES to detect the libxml2 library"
      url = "https://github.com/ldo/dvdauthor/commit/45705ece5ec5d7d6b9ab3e7a68194796a398e855.patch?full_index=1";
      hash = "sha256-tykCr2Axc1qhUvjlGyXQ6X+HwzuFTm5Va2gjGlOlSH0=";
    })
    ./gettext-0.25.patch
  ];

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
  ];

  strictDeps = true;

  meta = with lib; {
    description = "Tools for generating DVD files to be played on standalone DVD players";
    homepage = "https://dvdauthor.sourceforge.net/"; # or https://github.com/ldo/dvdauthor
    license = licenses.gpl2;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
