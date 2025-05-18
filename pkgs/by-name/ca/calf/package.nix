{
  lib,
  stdenv,
  cairo,
  expat,
  fftwSinglePrec,
  fluidsynth,
  glib,
  gtk2,
  libjack2,
  ladspaH,
  gnome2,
  lv2,
  pkg-config,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation rec {
  pname = "calf";
  version = "0.90.6";

  src = fetchFromGitHub {
    owner = "calf-studio-gear";
    repo = "calf";
    tag = version;
    hash = "sha256-rcMuQFig6BrnyGFyvYaAHmOvabEHGl+1lMNfffLHn1w=";
  };

  outputs = [
    "out"
    "doc"
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    cairo
    expat
    fftwSinglePrec
    fluidsynth
    glib
    gtk2
    libjack2
    ladspaH
    gnome2.libglade
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
}
