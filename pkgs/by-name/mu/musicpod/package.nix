{
  lib,
  flutter327,
  fetchFromGitHub,
  mpv-unwrapped,
  libass,
  pulseaudio,
  musicpod,
  runCommand,
  _experimental-update-script-combinators,
  yq,
  gitUpdater,
}:

flutter327.buildFlutterApplication rec {
  pname = "musicpod";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "ubuntu-flutter-community";
    repo = "musicpod";
    tag = "v${version}";
    hash = "sha256-jq133GdeuEENPb2igNWkjeFTpI5qqxF2RuCu78y6L8o=";
  };

  postPatch = ''
    substituteInPlace snap/gui/musicpod.desktop \
      --replace-fail 'Icon=''${SNAP}/meta/gui/musicpod.png' 'Icon=musicpod'
  '';

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = {
    audio_service_mpris = "sha256-QRZ4a3w4MZP8/A4yXzP4P9FPwEVNXlntmBwE8I+s2Kk=";
    media_kit = "sha256-uRQmrV1jAxsWXFm5SimAY/VYMHBB9fPSnRXvUCvEI8g=";
    media_kit_libs_video = "sha256-uRQmrV1jAxsWXFm5SimAY/VYMHBB9fPSnRXvUCvEI8g=";
    media_kit_video = "sha256-uRQmrV1jAxsWXFm5SimAY/VYMHBB9fPSnRXvUCvEI8g=";
    phoenix_theme = "sha256-HGMRQ5wdhoqYNkrjLTfz6mE/dh45IRyuQ79/E4oo+9w=";
    yaru = "sha256-lwyl5aRf5HzWHk7aXYXFj6a9QiFpDN9piHYXzVccYWY=";
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

  passthru = {
    pubspecSource =
      runCommand "pubspec.lock.json"
        {
          nativeBuildInputs = [ yq ];
          inherit (musicpod) src;
        }
        ''
          cat $src/pubspec.lock | yq > $out
        '';
    updateScript = _experimental-update-script-combinators.sequence [
      (gitUpdater { rev-prefix = "v"; })
      (_experimental-update-script-combinators.copyAttrOutputToFile "musicpod.pubspecSource" ./pubspec.lock.json)
    ];
  };

  meta = {
    description = "Music, radio, television and podcast player";
    homepage = "https://github.com/ubuntu-flutter-community/musicpod";
    license = lib.licenses.gpl3Only;
    mainProgram = "musicpod";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
}
