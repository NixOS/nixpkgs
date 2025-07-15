{
  lib,
  flutter329,
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

flutter329.buildFlutterApplication rec {
  pname = "musicpod";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "ubuntu-flutter-community";
    repo = "musicpod";
    tag = "v${version}";
    hash = "sha256-1elK3/jQ9KKqJYdU4CZd7rbIv8WK3H9AdBLH6QMqMmo=";
  };

  postPatch = ''
    substituteInPlace snap/gui/musicpod.desktop \
      --replace-fail 'Icon=''${SNAP}/meta/gui/musicpod.png' 'Icon=musicpod'
  '';

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes =
    let
      media_kit-hash = "sha256-uSVSLh4E/iUJaxA1JxKRYmDFyMpuoTWTyEwsbJuPldU=";
    in
    {
      audio_service_mpris = "sha256-QRZ4a3w4MZP8/A4yXzP4P9FPwEVNXlntmBwE8I+s2Kk=";
      media_kit = media_kit-hash;
      media_kit_libs_video = media_kit-hash;
      media_kit_video = media_kit-hash;
      phoenix_theme = "sha256-HGMRQ5wdhoqYNkrjLTfz6mE/dh45IRyuQ79/E4oo+9w=";
      yaru = "sha256-7frcJOVfeigQZf0t+7DXf92C2eNiG25RdkPk7+i0NUs=";
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
