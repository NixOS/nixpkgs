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
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "ubuntu-flutter-community";
    repo = "musicpod";
    rev = "refs/tags/v${version}";
    hash = "sha256-gsreA8ZTLcSvIAtODZ2gopZ78iyoN18gsSi9/IoY5/0=";
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
