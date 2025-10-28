{
  lib,
  fetchFromGitHub,
  flutter332,
  callPackage,
  makeDesktopItem,
  copyDesktopItems,

  # Needed for update script.
  _experimental-update-script-combinators,
  gitUpdater,
  runCommand,
  sideswap,
  yq,
}:

let
  # The Rust library is used by the main application.
  libsideswap-client = callPackage ./libsideswap-client.nix { };
in

flutter332.buildFlutterApplication rec {
  pname = "sideswap";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "sideswap-io";
    repo = "sideswapclient";
    tag = "v${version}";
    hash = "sha256-+zaQJCMKQZOrZ7i6CzgGTa+rJqpglaufUvYWSWMWTEw=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;
  gitHashes = lib.importJSON ./gitHashes.json;

  # Provide OpenGL and libsideswap_client.so for the Flutter application.
  extraWrapProgramArgs = ''
    --prefix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath [
        libsideswap-client
      ]
    }
  '';

  # Install icons.
  postInstall = ''
    install -D -m644 assets/icon/icon_linux.svg $out/share/icons/hicolor/scalable/apps/sideswap.svg
    install -D -m644 assets/icon/icon_linux.png $out/share/icons/hicolor/256x256/apps/sideswap.png
  '';

  # Install .desktop file.
  desktopItems = [
    (makeDesktopItem {
      name = "sideswap";
      exec = meta.mainProgram;
      desktopName = "SideSwap";
      genericName = "L-USDT Wallet";
      icon = "sideswap";
      comment = meta.description;
      categories = [
        "Finance"
        "Network"
      ];
      startupNotify = true;
      startupWMClass = "Sideswap";
      terminal = false;
    })
  ];
  nativeBuildInputs = [
    copyDesktopItems
  ];

  passthru = {
    # Expose lib to access it via sideswap.lib from the update script.
    lib = libsideswap-client;

    pubspecSource =
      runCommand "pubspec.lock.json"
        {
          nativeBuildInputs = [ yq ];
          inherit (sideswap) src;
        }
        ''
          cat $src/pubspec.lock | yq > $out
        '';

    # Usage: nix-shell maintainers/scripts/update.nix --argstr package sideswap
    updateScript = _experimental-update-script-combinators.sequence [
      # Update sideswap to new release.
      (gitUpdater { rev-prefix = "v"; })

      # Update pubspec.lock.json file and related gitHashes attribute.
      (_experimental-update-script-combinators.copyAttrOutputToFile "sideswap.pubspecSource" ./pubspec.lock.json)
      {
        command = [ ./update-gitHashes.py ];
        supportedFeatures = [ "silent" ];
      }

      # Update libsideswap-client sub-package.
      {
        command = [ ./update-libsideswap-client.sh ];
        supportedFeatures = [ "silent" ];
      }
    ];
  };

  meta = {
    description = "Cross‑platform, non‑custodial wallet and atomic swap marketplace for the Liquid Network";
    homepage = "https://sideswap.io/";
    license = lib.licenses.gpl3Only;
    mainProgram = "sideswap";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ starius ];
  };
}
