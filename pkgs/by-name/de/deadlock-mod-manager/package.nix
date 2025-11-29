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
  pname = "deadlock-mod-manager";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "deadlock-mod-manager";
    repo = "deadlock-mod-manager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nX31UA8wwjHDI0Co4+x6Una0QSd0LTzufJXYo9Zp7IY=";
  };

  cargoRoot = "apps/desktop";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoHash = "sha256-0SPWEEt4iO48FvIZc4JnZHvhEZxG7VF8dUhMrXUn4Ds=";

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
    hash = "sha256-e/jGSHR6w9VpPtWtltQgTEc6fxZ2AXJC4BzuFeCBXWs=";
  };

  patches = [
    ./no-updater-artifacts.patch
    ./disable-update-notice.patch
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
