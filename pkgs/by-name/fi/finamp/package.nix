{
  lib,
  stdenv,
  flutter338,
  mpv-unwrapped,
  patchelf,
  fetchFromGitHub,
  copyDesktopItems,
  makeDesktopItem,
  runCommand,
  yq,
  finamp,
  _experimental-update-script-combinators,
  nix-update-script,
  dart,
}:
let
  version = "0.9.22-beta";
in
flutter338.buildFlutterApplication {
  inherit version;
  pname = "finamp";
  src = fetchFromGitHub {
    owner = "jmshrv";
    repo = "finamp";
    rev = version;
    hash = "sha256-SPt1p9+uyvfSry8Ry2BJyLC7HyWZe43wfAPK9BVkcnc=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = lib.importJSON ./git-hashes.json;

  nativeBuildInputs = [
    patchelf
    copyDesktopItems
  ];
  buildInputs = [ mpv-unwrapped ];

  postFixup = ''
    patchelf $out/app/$pname/finamp --add-needed libisar.so --add-needed libmpv.so --add-needed libflutter_discord_rpc.so --add-rpath ${
      lib.makeLibraryPath [ mpv-unwrapped ]
    }
  '';

  postInstall = ''
    install -Dm444 assets/icon/icon_foreground.svg $out/share/icons/hicolor/scalable/apps/finamp.svg
    install -Dm444 assets/com.unicornsonlsd.finamp.metainfo.xml -t $out/share/metainfo
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "com.unicornsonlsd.finamp";
      desktopName = "Finamp";
      genericName = "Music Player";
      exec = "finamp";
      icon = "finamp";
      startupWMClass = "finamp";
      comment = "An open source Jellyfin music player";
      categories = [
        "AudioVideo"
        "Audio"
        "Player"
        "Music"
      ];
    })
  ];

  passthru = {
    pubspecSource =
      runCommand "pubspec.lock.json"
        {
          nativeBuildInputs = [ yq ];
          inherit (finamp) src;
        }
        ''
          cat $src/pubspec.lock | yq > $out
        '';
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script { extraArgs = [ "--version=unstable" ]; })
      (
        (_experimental-update-script-combinators.copyAttrOutputToFile "finamp.pubspecSource" ./pubspec.lock.json)
        // {
          supportedFeatures = [ ];
        }
      )
      {
        command = [
          dart.fetchGitHashesScript
          "--input"
          ./pubspec.lock.json
          "--output"
          ./git-hashes.json
        ];
        supportedFeatures = [ ];
      }
    ];
  };

  meta = {
    # Finamp depends on `ìsar`, which for Linux is only compiled for x86_64. https://github.com/jmshrv/finamp/issues/766
    broken = stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isx86_64;
    description = "Open source Jellyfin music player";
    homepage = "https://github.com/jmshrv/finamp";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ dseelp ];
    mainProgram = "finamp";
    platforms = lib.platforms.linux;
  };
}
