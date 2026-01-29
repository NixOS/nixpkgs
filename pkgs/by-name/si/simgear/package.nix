{
  lib,
  stdenv,
  fetchFromGitLab,
  plib,
  libglut,
  xorgproto,
  libX11,
  libXext,
  libXi,
  libICE,
  libSM,
  libXt,
  libXmu,
  libGLU,
  libGL,
  boost179,
  zlib,
  libjpeg,
  freealut,
  openscenegraph,
  openal,
  expat,
  cmake,
  apr,
  xz,
  curl,
  c-ares,
}:
let
  version = "2024.1.4";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "simgear";
  inherit version;

  src = fetchFromGitLab {
    owner = "flightgear";
    repo = "simgear";
    tag = finalAttrs.version;
    hash = "sha256-WJI15egN1H+EAIaFuI3svYCvM0xzsIGcIPsZgLsvBc0=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    plib
    libglut
    xorgproto
    libX11
    libXext
    libXi
    libICE
    libSM
    libXt
    libXmu
    libGLU
    libGL
    boost179
    zlib
    libjpeg
    freealut
    openscenegraph
    openal
    expat
    apr
    curl
    xz
  ];

  propagatedBuildInputs = [ c-ares ];

  meta = {
    description = "Simulation construction toolkit";
    homepage = "https://wiki.flightgear.org/SimGear";
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl2;
  };
})
