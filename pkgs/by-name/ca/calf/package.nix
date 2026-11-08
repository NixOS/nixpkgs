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
  version = "0.90.9";

  src = fetchFromGitHub {
    owner = "calf-studio-gear";
    repo = "calf";
    tag = finalAttrs.version;
    hash = "sha256-ypSoKUeJC8EUc0a5xIYQ/7/mSQKjWLqM4h/UrDRzujs=";
  };

  outputs = [
    "out"
    "doc"
  ];

  enableParallelBuilding = true;

  cmakeFlags = [
    (lib.cmakeBool "WANT_GUI" false)
    # upstream appends CMAKE_INSTALL_LIBDIR to CMAKE_INSTALL_PREFIX, so it must be relative
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
  ];

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
    maintainers = with lib.maintainers; [ kamadorueda ];
    platforms = lib.platforms.linux;
    mainProgram = "calfjackhost";
  };
})
