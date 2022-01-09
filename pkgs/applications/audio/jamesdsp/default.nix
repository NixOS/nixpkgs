{ lib
, mkDerivation
, fetchFromGitHub
, pipewire
, qtsvg
, glibmm
, libspatialaudio
, qmake
, git
, makeDesktopItem
, pkg-config
, libarchive
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

  patches = [ ./0001-Make-project-work-on-nix.patch ];
  nativeBuildInputs = [ qmake pkg-config ];
  buildInputs = [ glibmm libarchive pipewire ];

  propagatedBuildInput = [
    qtsvg
    pipewire
    glibmm
    libspatialaudio
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "jamesdsp.desktop";
      desktopName = "JamesDSP";
      genericName = "Audio effects processor";
      exec = "jamesdsp";
      icon = "jamesdsp";
      comment = "JamesDSP for Linux";
      categories = "AudioVideo;Audio";
      startupNotify = false;
      terminal = false;
      type = "Application";
      extraDesktopEntries = {
        Keywords = "equalizer;audio;effect";
      };
    })
  ];

  meta = with lib;{
    description = "An audio effect processor for PipeWire clients";
    homepage = "https://github.com/Audio4Linux/JDSP4Linux";
    license = licenses.gpl3Only;
    mantainer = with mantainers;[ pasqui23 ];
  };
}
