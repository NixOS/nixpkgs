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
}:
let
  version = "2024.1.1";
in
stdenv.mkDerivation rec {
  pname = "simgear";
  inherit version;

  src = fetchFromGitLab {
    owner = "flightgear";
    repo = "simgear";
    tag = "v${version}";
    hash = "sha256-hOA/q/cTsqRy82rTAXRxyHBDdw93TW9UL+K5Jq5b/08=";
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

  meta = with lib; {
    description = "Simulation construction toolkit";
    homepage = "https://wiki.flightgear.org/SimGear";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    license = licenses.lgpl2;
  };
}
