{
  lib,
  stdenv,
  rustPlatform,
  cargo,
  rustc,
  fetchFromGitLab,
  gtk4,
  libadwaita,
  openssl,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  glib,
  appstream-glib,
  desktop-file-utils,
  blueprint-compiler,
  sqlite,
  clapper,
  gettext,
  gst_all_1,
  gtuber,
  glib-networking,
  gnome,
  webp-pixbuf-loader,
  librsvg,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pipeline";
  version = "2.1.0";

  src = fetchFromGitLab {
    owner = "schmiddi-on-mobile";
    repo = "pipeline";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jAwVJjRU/Fq386XW4eQhiAe4IQUtQuYp35J2KSUNogY=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-VGWt7t5r0cDrO2WXpBqYM15HDfSRQ2MbSUWzdfU9JjA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    cargo
    rustPlatform.cargoSetupHook
    rustc
    pkg-config
    wrapGAppsHook4
    glib
    appstream-glib
    desktop-file-utils
    blueprint-compiler
  ];

  buildInputs = [
    gtk4
    libadwaita
    openssl
    sqlite
    clapper

    gst_all_1.gstreamer
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-base
    (gst_all_1.gst-plugins-good.override { gtkSupport = true; })
    gst_all_1.gst-plugins-bad
    gettext
    gtuber
    glib-networking # For GIO_EXTRA_MODULES. Fixes "TLS support is not available"
  ];

  # Pull in WebP support for YouTube avatars.
  # In postInstall to run before gappsWrapperArgsHook.
  postInstall = ''
    export GDK_PIXBUF_MODULE_FILE="${
      gnome._gdkPixbufCacheBuilder_DO_NOT_USE {
        extraLoaders = [
          webp-pixbuf-loader
          librsvg
        ];
      }
    }"
  '';

  passthru.updateScript = nix-update-script { attrPath = finalAttrs.pname; };

  meta = {
    description = "Watch YouTube and PeerTube videos in one place";
    homepage = "https://mobile.schmidhuberj.de/pipeline";
    mainProgram = "tubefeeder";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ chuangzhu ];
    platforms = lib.platforms.linux;
  };
})
