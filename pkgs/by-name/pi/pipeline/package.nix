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
  clapper-unwrapped,
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
  version = "3.1.1";

  src = fetchFromGitLab {
    owner = "schmiddi-on-mobile";
    repo = "pipeline";
    rev = finalAttrs.version;
    hash = "sha256-iMBdyjN6fMDOSE110tA9i6+D4UaNGG2aBoq+4s0YyJI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-w+q90i6FQRPFceniUfwouU2p673O4sVnsRfowCu2fWY=";
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
    clapper-unwrapped

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
