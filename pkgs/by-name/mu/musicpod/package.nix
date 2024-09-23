{
  lib,
  flutter324,
  fetchFromGitHub,
  mpv-unwrapped,
  libass,
  pulseaudio,
}:

flutter324.buildFlutterApplication rec {
  pname = "musicpod";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "ubuntu-flutter-community";
    repo = "musicpod";
    rev = "v${version}";
    hash = "sha256-Xs6qDSqd10mYjLNFiPV9Irthd/hK2kE4fC6i03QvOn0=";
  };

  postPatch = ''
    substituteInPlace snap/gui/musicpod.desktop \
      --replace-fail 'Icon=''${SNAP}/meta/gui/musicpod.png' 'Icon=musicpod'
  '';

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = {
    audio_service_mpris = "sha256-QRZ4a3w4MZP8/A4yXzP4P9FPwEVNXlntmBwE8I+s2Kk=";
    media_kit_native_event_loop = "sha256-JBtFTYlztDQvN/qQcDxkK27mka2fSG+iiIIxk2mqEpY=";
    media_kit_video = "sha256-JBtFTYlztDQvN/qQcDxkK27mka2fSG+iiIIxk2mqEpY=";
    phoenix_theme = "sha256-5kgPAnK61vFi/sJ1jr3c5D2UZbxItW8YOk/IJEtHkZo=";
    yaru = "sha256-3GexoQpwr7pazajAMyPl9rcYhmSgQeialZTvJsadP4k=";
  };

  buildInputs = [
    mpv-unwrapped
    libass
  ];

  runtimeDependencies = [ pulseaudio ];

  postInstall = ''
    install -Dm644 snap/gui/musicpod.desktop -t $out/share/applications
    install -Dm644 snap/gui/musicpod.png -t $out/share/pixmaps
  '';

  meta = {
    description = "Music, radio, television and podcast player";
    homepage = "https://github.com/ubuntu-flutter-community/musicpod";
    license = lib.licenses.gpl3Only;
    mainProgram = "musicpod";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
}
