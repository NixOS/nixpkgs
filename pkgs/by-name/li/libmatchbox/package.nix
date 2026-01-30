{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  libICE,
  libjpeg,
  libpng,
  libX11,
  libXext,
  libXft,
  pango,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmatchbox";
  version = "1.14";

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  propagatedBuildInputs = [
    libICE
    libjpeg
    libpng
    libX11
    libXext
    libXft
    pango
  ];

  src = fetchurl {
    url = "https://git.yoctoproject.org/libmatchbox/snapshot/libmatchbox-${finalAttrs.version}.tar.gz";
    sha256 = "1b66jl178pkwmswf1gqcyrpy15rll1znz38n07l9b3ybga13w31d";
  };

  meta = {
    description = "Library of the matchbox X window manager";
    homepage = "http://matchbox-project.org/";
    license = with lib.licenses; [
      lgpl2Plus
      hpnd
    ];
    platforms = lib.platforms.unix;
  };
})
