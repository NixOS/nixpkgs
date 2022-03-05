{ lib
, mkDerivation
, fetchFromGitHub
, pipewire
, glibmm
, qmake
, makeDesktopItem
, pkg-config
, libarchive
, fetchpatch
}:

mkDerivation rec{
  pname = "jamesdsp";
  version = "2.3";
  src = fetchFromGitHub rec{
    owner = "Audio4Linux";
    repo = "JDSP4Linux";
    fetchSubmodules = true;
    rev = version;
    hash = "sha256-Hkzurr+s+vvSyOMCYH9kHI+nIm6mL9yORGNzY2FXslc=";
  };

  patches = [
    # fixing /usr install assumption, remove on version bump
    (fetchpatch {
      url = "https://github.com/Audio4Linux/JDSP4Linux/commit/003c9e9fc426f83e269aed6e05be3ed55273931a.patch";
      hash = "sha256-crll/a7C9pUq9eL5diq8/YgC5bNC6SrdijZEBxZpJ8E=";
    })
  ];

  nativeBuildInputs = [ qmake pkg-config ];
  buildInputs = [
    glibmm
    libarchive
    pipewire
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "jamesdsp";
      desktopName = "JamesDSP";
      genericName = "Audio effects processor";
      exec = "jamesdsp";
      icon = "jamesdsp";
      comment = "JamesDSP for Linux";
      categories = [ "AudioVideo" "Audio" ];
      startupNotify = false;
      keywords = [ "equalizer" "audio" "effect" ];
    })
  ];

  meta = with lib;{
    description = "An audio effect processor for PipeWire clients";
    homepage = "https://github.com/Audio4Linux/JDSP4Linux";
    license = licenses.gpl3Only;
    maintainers = with maintainers;[ pasqui23 ];
    platforms = platforms.linux;
  };
}
