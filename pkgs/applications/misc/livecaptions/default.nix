{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  cmake,
  desktop-file-utils,
  wrapGAppsHook4,
  onnxruntime,
  libadwaita,
  libpulseaudio,
  xorg,
}: let
  aprilAsr = fetchFromGitHub {
    name = "april-asr";
    owner = "abb128";
    repo = "april-asr";
    rev = "c2f138c674cad58e2708ecaddc95cc72e7f85549";
    hash = "sha256-hZe2iss3BGdzeTM5FCp9wp6LaDOjtGJrZS5vB5F6uLg=";
  };

  aprilModel = fetchurl {
    name = "april-english-dev-01110_en.april";
    url = "https://april.sapples.net/april-english-dev-01110_en.april";
    hash = "sha256-d+uV0PpPdwijfoaMImUwHubELcsl5jymPuo9nLrbwfM=";
  };
in
  stdenv.mkDerivation rec {
    pname = "livecaptions";
    version = "0.4.0";

    src = fetchFromGitHub {
      owner = "abb128";
      repo = "LiveCaptions";
      rev = "v${version}";
      hash = "sha256-RepuvqNPHRGENupPG5ezadn6f7FxEUYFDi4+DpNanuA=";
    };

    nativeBuildInputs = [
      meson
      ninja
      pkg-config
      cmake
      desktop-file-utils # update-desktop-database
      wrapGAppsHook4
    ];

    buildInputs = [
      onnxruntime
      libadwaita
      libpulseaudio
      xorg.libX11
    ];

    postUnpack = ''
      rm -r source/subprojects/april-asr
      ln -sf ${aprilAsr} source/subprojects/april-asr
    '';

    preFixup = ''
      gappsWrapperArgs+=(
        --set APRIL_MODEL_PATH ${aprilModel}
      )
    '';

    meta = with lib; {
      description = "Linux Desktop application that provides live captioning";
      homepage = "https://github.com/abb128/LiveCaptions";
      license = licenses.gpl3Plus;
      platforms = platforms.linux;
      maintainers = with maintainers; [Scrumplex];
    };
  }
