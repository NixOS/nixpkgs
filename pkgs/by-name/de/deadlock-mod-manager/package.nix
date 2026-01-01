{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cargo-tauri,
  nodejs,
  pnpm_9,
<<<<<<< HEAD
  fetchPnpmDeps,
  pnpmConfigHook,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "deadlock-mod-manager";
  version = "0.13.0";
=======

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "deadlock-mod-manager";
  version = "0.10.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "deadlock-mod-manager";
    repo = "deadlock-mod-manager";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-ja7B48UVpwj1gCZfrFWZjtTTaUh1QLTAE88oXwDt18Y=";
=======
    hash = "sha256-/84P9ONG25Ia1BnRcbzQuJKt8HwstCzf0bkx1Xc9VgU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  cargoRoot = "apps/desktop";
  buildAndTestSubdir = finalAttrs.cargoRoot;

<<<<<<< HEAD
  cargoHash = "sha256-PeY59bvL/JGl8KyE0X+nPY3XC4TNa15lGcG2i///bCI=";
=======
  cargoHash = "sha256-wVsr6GwCGuuveTDT6oS1keejx+y+oSuE6dGAjvNRrdE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo-tauri.hook
    nodejs
<<<<<<< HEAD
    pnpmConfigHook
    pnpm_9
=======
    pnpm_9.configHook
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
  pnpmDeps = fetchPnpmDeps {
=======
  pnpmDeps = pnpm_9.fetchDeps {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    inherit (finalAttrs)
      pname
      version
      src
      ;
<<<<<<< HEAD
    pnpm = pnpm_9;
    fetcherVersion = 2;
    sourceRoot = "source";
    hash = "sha256-dS9s5oy8GtRek7OwiGDwv7280zZuyjxIhiA6BqH8C1w=";
=======
    fetcherVersion = 2;
    sourceRoot = "source";
    hash = "sha256-7HhMW28hl2hHi8epcKMTbfuVjKYj+U1N/d2tMcu4aQg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  patches = [
    ./no-updater-artifacts.patch
<<<<<<< HEAD
=======
    ./disable-update-notice.patch
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
      --set DISABLE_UPDATE_DESKTOP_DATABASE 1
      --prefix PATH : ${lib.makeBinPath [ desktop-file-utils ]}
      --add-flags "--disable-auto-update"
=======
      --set WEBKIT_DISABLE_COMPOSITING_MODE 1
      --set WEBKIT_DISABLE_DMABUF_RENDERER 1
      --set DISABLE_UPDATE_DESKTOP_DATABASE 1
      --prefix PATH : ${lib.makeBinPath [ desktop-file-utils ]}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
