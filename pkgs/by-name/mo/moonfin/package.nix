{
  lib,
  flutter347,
  fetchFromGitHub,
  copyDesktopItems,
  makeDesktopItem,
  gtk3,
  libepoxy,
  libsecret,
  mpv-unwrapped,
  alsa-lib,
  webkitgtk_4_1,
  moonfin,
  runCommand,
  yq-go,
  _experimental-update-script-combinators,
  nix-update-script,
  dart,
}:

flutter347.buildFlutterApplication (finalAttrs: {
  pname = "moonfin";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "Moonfin-Client";
    repo = "Moonfin-Core";
    tag = finalAttrs.version;
    hash = "sha256-dHY0qNToNSgHU6rv3RD3B8vsuHRh3vQq+a3JhzVcNkU=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  # Under `__structuredAttrs = true`, passAsFile leaves pubspecLockFilePath empty.
  env.pubspecLockFilePath = "./pubspec.lock.json";

  gitHashes = lib.importJSON ./git-hashes.json;

  nativeBuildInputs = [ copyDesktopItems ];

  buildInputs = [
    gtk3
    libepoxy
    libsecret
    mpv-unwrapped
    alsa-lib
    webkitgtk_4_1
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "org.moonfin.linux";
      desktopName = "Moonfin";
      genericName = "Media Client";
      exec = "moonfin %U";
      icon = "org.moonfin.linux";
      comment = "Jellyfin & Emby media client";
      categories = [
        "AudioVideo"
        "Video"
      ];
      startupWMClass = "org.moonfin.linux";
      mimeTypes = [ "x-scheme-handler/moonfin" ];
    })
  ];

  postInstall = ''
    install -Dm644 assets/icons/moonfin.png \
      $out/share/icons/hicolor/512x512/apps/org.moonfin.linux.png
  '';

  passthru = {
    pubspecSource =
      runCommand "pubspec.lock.json"
        {
          inherit (moonfin) src;
          nativeBuildInputs = [ yq-go ];
        }
        ''
          yq eval --output-format=json --prettyPrint $src/pubspec.lock > "$out"
        '';
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script { })
      (
        (_experimental-update-script-combinators.copyAttrOutputToFile "moonfin.pubspecSource" ./pubspec.lock.json)
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
    description = "Jellyfin & Emby media client";
    homepage = "https://github.com/Moonfin-Client/Moonfin-Core";
    changelog = "https://github.com/Moonfin-Client/Moonfin-Core/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ clementinator ];
    mainProgram = "moonfin";
    platforms = lib.platforms.linux;
  };
})
