{ lib
, stdenv
, fetchFromGitHub
, vala
, meson
, ninja
, python3
, pkg-config
, wrapGAppsHook4
, desktop-file-utils
, gtk4
, libadwaita
, json-glib
, glib
, glib-networking
, gnome
, gobject-introspection
, gtksourceview5
, libxml2
, libgee
, librsvg
, libsoup_3
, libsecret
, libwebp
, libspelling
, webp-pixbuf-loader
, icu
, gst_all_1
, clapper
# clapper support is still experimental and has bugs.
# See https://github.com/GeopJr/Tuba/pull/931
, clapperSupport? false
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "tuba";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "GeopJr";
    repo = "Tuba";
    rev = "v${version}";
    hash = "sha256-nBNb2Hqv2AumwYoQnYZnH6YGp9wGr1o9vRO8YOty214=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    python3
    wrapGAppsHook4
    desktop-file-utils
    gobject-introspection
  ];

  buildInputs = [
    glib
    glib-networking
    gtksourceview5
    json-glib
    libxml2
    libgee
    libsoup_3
    gtk4
    libadwaita
    libsecret
    libwebp
    libspelling
    icu
  ] ++ (with gst_all_1; [
    gstreamer
    gst-libav
    gst-plugins-base
    (gst-plugins-good.override { gtkSupport = true; })
    gst-plugins-bad
  ]) ++ lib.optionals clapperSupport [
    clapper
  ];

  mesonFlags = [
    (lib.mesonBool "clapper" clapperSupport)
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=int-conversion";

  passthru = {
    updateScript = nix-update-script { };
  };

  # Pull in WebP support for avatars from Misskey instances.
  # In postInstall to run before gappsWrapperArgsHook.
  postInstall = ''
    export GDK_PIXBUF_MODULE_FILE="${gnome._gdkPixbufCacheBuilder_DO_NOT_USE {
      extraLoaders = [
        librsvg
        webp-pixbuf-loader
      ];
    }}"
  '';

  meta = {
    description = "Browse the Fediverse";
    homepage = "https://tuba.geopjr.dev/";
    mainProgram = "dev.geopjr.Tuba";
    license = lib.licenses.gpl3Only;
    changelog = "https://github.com/GeopJr/Tuba/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ chuangzhu aleksana donovanglover ];
  };
}
