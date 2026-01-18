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
  appstream,
  desktop-file-utils,
  blueprint-compiler,
  sqlite,
  clapper-unwrapped,
  clapper-enhancers,
  gettext,
  gst_all_1,
  glib-networking,
  gnome,
  libjxl,
  libheif,
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
    tag = finalAttrs.version;
    hash = "sha256-iMBdyjN6fMDOSE110tA9i6+D4UaNGG2aBoq+4s0YyJI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src pname version;
    hash = "sha256-w+q90i6FQRPFceniUfwouU2p673O4sVnsRfowCu2fWY=";
  };

  nativeBuildInputs = [
    meson
    ninja
    cargo
    gettext
    rustPlatform.cargoSetupHook
    rustc
    pkg-config
    wrapGAppsHook4
    glib
    appstream
    desktop-file-utils
    blueprint-compiler
  ];

  buildInputs = [
    gtk4
    libadwaita
    openssl
    sqlite
    clapper-unwrapped
    clapper-enhancers
    gst_all_1.gstreamer
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-vaapi
    glib-networking # For GIO_EXTRA_MODULES. Fixes "TLS support is not available"
  ];

  preFixup = ''
    gappsWrapperArgs+=(
       --set GDK_PIXBUF_MODULE_FILE ${
         gnome._gdkPixbufCacheBuilder_DO_NOT_USE {
           extraLoaders = [
             libjxl
             librsvg
             webp-pixbuf-loader
             libheif.lib
           ];
         }
       }
       --set CLAPPER_ENHANCERS_PATH ${clapper-enhancers}/${clapper-enhancers.passthru.pluginPath}
    )
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Watch YouTube and PeerTube videos in one place";
    homepage = "https://mobile.schmidhuberj.de/pipeline";
    mainProgram = "tubefeeder";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      chuangzhu
    ];
    platforms = lib.platforms.linux;
  };
})
