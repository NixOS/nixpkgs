{
  atk,
  cairo,
  cargo-tauri,
  dbus,
  fetchFromGitHub,
  fetchNpmDeps,
  ffmpeg,
  gdk-pixbuf,
  glib,
  gst_all_1,
  gtk3,
  harfbuzz,
  lib,
  libgit2,
  libsoup_3,
  nodejs,
  npmHooks,
  openssl,
  pango,
  pkg-config,
  rustPlatform,
  typescript,
  webkitgtk_4_1,
  wrapGAppsHook4,
  zlib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mediaharbor";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "MediaHarbor";
    repo = "mediaharbor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XGND7sT099xg9lObtYiv4MTLsgZxoiUC1r9V7crxrt8=";
  };

  __structuredAttrs = true;
  env.LIBGIT2_NO_VENDOR = true;

  cargoHash = "sha256-GoyY4dSeDO3ue0c/5QdRGFFHegJID4DWGGbcuCAZeOc=";

  cargoBuildFlags = [
    "-p"
    "mediaharbor"
  ];

  npmRebuildFlags = [ "--ignore-scripts" ];

  npmDeps = fetchNpmDeps {
    src = finalAttrs.src;
    hash = "sha256-66Z42cZQ/bW5Dn0Wfz6MWbIgrI9NF3XsNj4j5KhIzBY=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
    pkg-config
    typescript
    wrapGAppsHook4
  ];

  buildInputs = [
    atk
    cairo
    dbus
    ffmpeg
    gdk-pixbuf
    glib
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gtk3
    harfbuzz
    libgit2
    libsoup_3
    nodejs
    openssl
    pango
    webkitgtk_4_1
    zlib
  ];

  preBuild = ''
    npm run build:react
  '';

  dontUseCargoInstall = true;

  installPhase = ''
    mkdir -p $out/bin $out/share
    install -Dm755 target/x86_64-unknown-linux-gnu/release/mediaharbor $out/bin/
    cp -r target/x86_64-unknown-linux-gnu/release/bundle/deb/MediaHarbor_*/data/usr/share/* $out/share/ || true
  '';

  meta = {
    description = "Cross-platform Media Ripping and Browsing GUI";
    homepage = "https://mediaharbor.org/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ idkdontaskm3 ];
    mainProgram = "mediaharbor";
  };
})
