{
  lib,
  stdenv,
  expat,
  fftwSinglePrec,
  fluidsynth,
  libjack2,
  ladspa-header,
  lv2,
  pkg-config,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "calf";
  version = "0.90.6";

  src = fetchFromGitHub {
    owner = "calf-studio-gear";
    repo = "calf";
    tag = finalAttrs.version;
    hash = "sha256-rcMuQFig6BrnyGFyvYaAHmOvabEHGl+1lMNfffLHn1w=";
  };

  outputs = [
    "out"
    "doc"
  ];

  enableParallelBuilding = true;

  cmakeFlags = [ (lib.cmakeBool "WANT_GUI" false) ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    expat
    fftwSinglePrec
    fluidsynth
    libjack2
    ladspa-header
    lv2
  ];

  meta = {
    homepage = "https://calf-studio-gear.org";
    description = "Set of high quality open source audio plugins for musicians";
    license = lib.licenses.lgpl2;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "calfjackhost";
  };
})
