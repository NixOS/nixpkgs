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
<<<<<<< HEAD
  c-ares,
}:
let
  version = "2024.1.3";
=======
}:
let
  version = "2024.1.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
in
stdenv.mkDerivation rec {
  pname = "simgear";
  inherit version;

  src = fetchFromGitLab {
    owner = "flightgear";
    repo = "simgear";
<<<<<<< HEAD
    tag = "${version}";
    hash = "sha256-1zbw/lIjTbVwhxHPvXRlxPmYJeWmKvPE/RDrTL0PXb4=";
=======
    tag = "v${version}";
    hash = "sha256-hOA/q/cTsqRy82rTAXRxyHBDdw93TW9UL+K5Jq5b/08=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  propagatedBuildInputs = [ c-ares ];

  meta = {
    description = "Simulation construction toolkit";
    homepage = "https://wiki.flightgear.org/SimGear";
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl2;
=======
  meta = with lib; {
    description = "Simulation construction toolkit";
    homepage = "https://wiki.flightgear.org/SimGear";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    license = licenses.lgpl2;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
