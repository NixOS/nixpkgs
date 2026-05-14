{
  lib,
  fetchFromGitHub,
  fetchNpmDeps,
  npmHooks,
  rustPlatform,
  wrapGAppsHook3,
  alsa-lib,
  cargo-tauri,
  dbus,
  glib-networking,
  gst_all_1,
  gtk3,
  librsvg,
  libsecret,
  nix-update-script,
  nodejs,
  openssl,
  pkg-config,
  webkitgtk_4_1,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sone";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "lullabyX";
    repo = "sone";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QxA9ab/BVmYvsZb++ykWZ80TDpIMWQb5LJazdUab+pM=";
  };

  cargoHash = "sha256-zWW/x92/HAa6AsXe0fIQmQrGKtsR2sX/vyG7uwsl3Bc=";

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-npm-deps-${finalAttrs.version}";
    inherit (finalAttrs) src;
    hash = "sha256-MORNCIA/LC6DTNUqXvKk4hHnoKDZEC+poANcNOHQPyM=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    alsa-lib
    dbus
    glib-networking
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gstreamer
    gtk3
    librsvg
    libsecret
    openssl
    webkitgtk_4_1
  ];

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Native Linux desktop client for TIDAL";
    homepage = "https://github.com/lullabyX/sone";
    changelog = "https://github.com/lullabyX/sone/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ andresilva ];
    mainProgram = "sone";
    platforms = lib.platforms.linux;
  };
})
