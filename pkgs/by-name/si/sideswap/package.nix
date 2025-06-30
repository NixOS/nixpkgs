{
  lib,
  fetchFromGitHub,
  flutter332,
  mesa,
  libglvnd,
  callPackage,
  makeDesktopItem,
  copyDesktopItems,
}:

let
  # The Rust library is used by the main application.
  libsideswap-client = callPackage ./libsideswap-client.nix { };
in

flutter332.buildFlutterApplication rec {
  pname = "sideswap";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "sideswap-io";
    repo = "sideswapclient";
    tag = "v${version}";
    hash = "sha256-IUUMlaEIUil07nhjep1I+F1WEWakQZfhy42ZlnyRLcQ=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = {
    sideswap_logger = "sha256-cTJfSODRmIJXctLQ++BfvJ6OKflau94AjQdXg7j95B0=";
    sideswap_websocket = "sha256-vsG5eUFu/WJvY3y6jaWD/5GfULwpqh3bO4EZmmBSkbs=";
    window_size = "sha256-+lqY46ZURT0qcqPvHFXUnd83Uvfq79Xr+rw1AHqrpak=";
  };

  # Provide OpenGL and libsideswap_client.so for the Flutter application.
  extraWrapProgramArgs = ''
    --set LD_LIBRARY_PATH ${
      lib.makeLibraryPath [
        mesa
        libglvnd
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

  meta = {
    description = "Cross‑platform, non‑custodial wallet and atomic swap marketplace for the Liquid Network";
    homepage = "https://sideswap.io/";
    license = lib.licenses.gpl3Only;
    mainProgram = "sideswap";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ starius ];
  };
}
