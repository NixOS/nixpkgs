{
  lib,
  stdenv,
  fetchFromGitLab,
  plib,
  libglut,
  xorgproto,
  libx11,
  libxext,
  libxi,
  libice,
  libsm,
  libxt,
  libxmu,
  libGLU,
  libGL,
  boost,
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
  version = "2024.1.5";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "simgear";
  inherit version;

  src = fetchFromGitLab {
    owner = "flightgear";
    repo = "simgear";
    tag = finalAttrs.version;
    hash = "sha256-WONlVdfDWIcoj/UfcFA4Vw5edlgr0vlT/fjIPDti7fk=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    plib
    boost
    zlib
    libjpeg
    freealut
    openscenegraph
    openal
    expat
    apr
    curl
    xz
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libglut
    xorgproto
    libx11
    libxext
    libxi
    libice
    libsm
    libxt
    libxmu
    libGLU
    libGL
  ];

  propagatedBuildInputs = [ c-ares ];

  meta = {
    description = "Simulation construction toolkit";
    homepage = "https://wiki.flightgear.org/SimGear";
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.lgpl2;
  };
})
