{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cargo-tauri,
  nodejs,
  pnpm_9,
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
  pname = "deadlock-modmanager";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "Stormix";
    repo = "deadlock-modmanager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-meCwpdnRYwNiOB8QzdhDC24CtRiMClimCDlv0EvHHgI=";
  };

  cargoRoot = "apps/desktop";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoHash = "sha256-cLdsR9ZCkUKZQDAxsvZpau7c9LxeLt4kUI21ObiY7dA=";

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo-tauri.hook
    nodejs
    pnpm_9.configHook
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
  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    fetcherVersion = 2;
    sourceRoot = "source";
    hash = "sha256-ZnVUQjPXphwk7J5jd04WQdUYQF0t5veqRVr/m4guuEU=";
  };

  patches = [
    ./no-updater-artifacts.patch
  ];

  VITE_API_URL = "https://api.deadlockmods.app";

  preFixup = ''
    gappsWrapperArgs+=(
      --set FONTCONFIG_FILE "${fontconfig.out}/etc/fonts/fonts.conf"
      --set TAURI_DIST_DIR "$out/share/deadlock-modmanager/dist"
      --set WEBKIT_DISABLE_COMPOSITING_MODE 1
      --set WEBKIT_DISABLE_DMABUF_RENDERER 1
      --set DISABLE_UPDATE_DESKTOP_DATABASE 1
      --prefix PATH : ${lib.makeBinPath [ desktop-file-utils ]}
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
    homepage = "https://github.com/Stormix/deadlock-modmanager";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      mistyttm
      schromp
    ];
    platforms = lib.platforms.linux;
    mainProgram = "deadlock-mod-manager";
  };
})
