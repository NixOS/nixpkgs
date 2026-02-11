{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cargo-tauri,
  nodejs,
  pnpm_9,
  fetchPnpmDeps,
  pnpmConfigHook,
  pkg-config,
  wrapGAppsHook3,
  desktop-file-utils,
  webkitgtk_4_1,
  cairo,
  gdk-pixbuf,
  glib,
  glib-networking,
  gtk3,
  libsoup_3,
  pango,
  openssl,
  bzip2,
  gst_all_1,
  makeDesktopItem,
  fontconfig,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "deadlock-mod-manager";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "deadlock-mod-manager";
    repo = "deadlock-mod-manager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A7RsgPi3NlcLSBkLg7/pWcSduaZyCspz19sjGjzEkqM=";
  };

  cargoRoot = "apps/desktop";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoHash = "sha256-L4orWiK1s1hfC2QDJ8G4hI1iqrdPHBaVTVHoW0hdlGo=";

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo-tauri.hook
    nodejs
    pnpmConfigHook
    pnpm_9
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    webkitgtk_4_1
    cairo
    gdk-pixbuf
    glib
    glib-networking
    gtk3
    libsoup_3
    pango
    openssl
    bzip2
    desktop-file-utils
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
  ];

  pnpmRoot = ".";
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    pnpm = pnpm_9;
    fetcherVersion = 2;
    sourceRoot = "source";
    hash = "sha256-KhBWFujjo3FW3intvGA2Y7eLIdJ1B/4P5xIRPvzygT8=";
  };

  patches = [
    ./no-updater-artifacts.patch
  ];

  VITE_API_URL = "https://api.deadlockmods.app";

  # Skip tests that require network access
  checkFlags = [
    "--skip=download_manager::downloader::tests::test_download_file"
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --set FONTCONFIG_FILE "${fontconfig.out}/etc/fonts/fonts.conf"
      --set TAURI_DIST_DIR "$out/share/deadlock-modmanager/dist"
      --set DISABLE_UPDATE_DESKTOP_DATABASE 1
      --prefix PATH : ${lib.makeBinPath [ desktop-file-utils ]}
      --add-flags "--disable-auto-update"
    )
  '';

  desktopItems = [
    (makeDesktopItem {
      desktopName = "deadlock-mod-manager";
      name = "Deadlock Mod Manager";
      exec = "deadlock-mod-manager %u";
      terminal = false;
      type = "Application";
      icon = "deadlock-mod-manager";
      mimeTypes = [ "x-scheme-handler/deadlock-mod-manager" ];
      categories = [
        "Utility"
        "Game"
      ];
    })
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Mod manager for the Valve game Deadlock";
    homepage = "https://github.com/deadlock-mod-manager/deadlock-mod-manager";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      mistyttm
      schromp
    ];
    platforms = lib.platforms.linux;
    mainProgram = "deadlock-mod-manager";
  };
})
