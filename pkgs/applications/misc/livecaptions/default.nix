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
    rev = "3308e68442664552de593957cad0fa443ea183dd";
    hash = "sha256-/cOZ2EcZu/Br9v0ComxnOegcEtlC9e8FYt3XHfah7mE=";
  };

  aprilModel = fetchurl {
    name = "april-english-dev-01110_en.april";
    url = "https://april.sapples.net/april-english-dev-01110_en.april";
    hash = "sha256-d+uV0PpPdwijfoaMImUwHubELcsl5jymPuo9nLrbwfM=";
  };
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "livecaptions";
    version = "0.4.1";

    src = fetchFromGitHub {
      owner = "abb128";
      repo = "LiveCaptions";
      rev = "v${finalAttrs.version}";
      hash = "sha256-x8NetSooIBlOKzKUMvDkPFtpD6EVGYECnaqWurySUDU=";
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
      mainProgram = "livecaptions";
    };
  })
