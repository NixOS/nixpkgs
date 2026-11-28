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
  version = "4.1.3";

  src = fetchFromGitLab {
    owner = "schmiddi-on-mobile";
    repo = "pipeline";
    tag = finalAttrs.version;
    hash = "sha256-m9pzAsRhIhV2S7Jb2kNmkk3U1FPDYXAIAm1epmdEb/c=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src pname version;
    hash = "sha256-7L+iJQ0/JQqADCaGkJ048YT8ecUqi7kHoxHqJr5or4s=";
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
      Kladki
    ];
    platforms = lib.platforms.linux;
  };
})
