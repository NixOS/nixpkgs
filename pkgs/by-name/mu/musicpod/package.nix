{
  lib,
  flutter335,
  fetchFromGitHub,
  alsa-lib,
  mpv-unwrapped,
  libass,
  libnotify,
  pulseaudio,
  musicpod,
  runCommand,
  _experimental-update-script-combinators,
  yq,
  gitUpdater,
}:

flutter335.buildFlutterApplication rec {
  pname = "musicpod";
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = "ubuntu-flutter-community";
    repo = "musicpod";
    tag = "v${version}";
    hash = "sha256-AUggxf6qveyLiEhXeA9orVzy03bl6eBHHEh15zZQ0wE=";
  };

  postPatch = ''
    substituteInPlace snap/gui/musicpod.desktop \
      --replace-fail 'Icon=''${SNAP}/meta/gui/musicpod.png' 'Icon=musicpod'
  '';

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = lib.importJSON ./gitHashes.json;

  buildInputs = [
    alsa-lib
    mpv-unwrapped
    libass
    libnotify
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
      {
        command = [ ./update-gitHashes.py ];
        supportedFeatures = [ "silent" ];
      }
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
