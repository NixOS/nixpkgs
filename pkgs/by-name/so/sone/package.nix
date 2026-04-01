{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  fetchNpmDeps,
  cargo-tauri,
  nodejs,
  npmHooks,
  alsa-lib,
  glib-networking,
  openssl,
  pkg-config,
  webkitgtk_4_1,
  wrapGAppsHook3,
  gtk3,
  libayatana-appindicator,
  librsvg,
  gst_all_1,
  libsecret,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sone";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "lullabyX";
    repo = "sone";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8vdpEjo2UP3vh/PL8+lhLPDfuHeI9kI2/AQvVsWlR1w=";
  };

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-EOmoryKKWCttpOpIAOpdIz7yOA5hm/Hg1WFbcXWr5tc=";
  };

  cargoHash = "sha256-zsEO/YnipPNm7TSWcM3tQ+oOF8M5VK5BiUMhsvPcGwQ=";

  nativeBuildInputs = [
    cargo-tauri.hook

    nodejs
    npmHooks.npmConfigHook

    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook3 ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    glib-networking
    openssl
    webkitgtk_4_1
    gtk3
    libayatana-appindicator
    librsvg

    # Video/Audio data composition framework tools like "gst-inspect", "gst-launch" ...
    gst_all_1.gstreamer
    # Common plugins like "filesrc" to combine within e.g. gst-launch
    gst_all_1.gst-plugins-base
    # Specialized plugins separated by quality
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    # Plugins to reuse ffmpeg to play almost every video format
    gst_all_1.gst-libav
    # Support the Video Audio (Hardware) Acceleration API
    gst_all_1.gst-vaapi

    libsecret
  ];

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  meta = {
    description = "Native community TIDAL desktop client for Linux supporting bit-perfect lossless audio up to 24-bit/192kHz via exclusive ALSA.";
    homepage = "https://github.com/lullabyX/sone";
    license = lib.licenses.gpl3;
    mainProgram = "sone";
    maintainers = with lib.maintainers; [ jiriks74 ];
  };
})
