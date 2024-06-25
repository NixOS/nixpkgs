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
, gobject-introspection
, gtksourceview5
, libxml2
, libgee
, libsoup_3
, libsecret
, libwebp
, libspelling
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
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "GeopJr";
    repo = "Tuba";
    rev = "v${version}";
    hash = "sha256-dN915sPBttnrcOuhUJjEtdojOQi9VRLmc+t1RvWmx64=";
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

  meta = {
    description = "Browse the Fediverse";
    homepage = "https://tuba.geopjr.dev/";
    mainProgram = "dev.geopjr.Tuba";
    license = lib.licenses.gpl3Only;
    changelog = "https://github.com/GeopJr/Tuba/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ chuangzhu aleksana ];
  };
}
