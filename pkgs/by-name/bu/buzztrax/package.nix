{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gtk-doc,
  intltool,
  itstool,
  libtool,
  pkg-config,
  wrapGAppsHook3,
  yelp-tools,
  clutter-gtk,
  gstreamer,
  gst-plugins-ugly,
  gst-plugins-good,
  gst-plugins-base,
  gst-plugins-bad,
  glib,
  gtk3,
  libgsf,
  libxml2,
  fluidsynth,
  orc,
}:

stdenv.mkDerivation {
  pname = "buzztrax";
  version = "0.11.0-unstable-2024-03-02";

  src = fetchFromGitHub {
    owner = "Buzztrax";
    repo = "buzztrax";
    rev = "4bb66d9d9870e1e56ce1f0e97bb58a0c627356d3";
    hash = "sha256-AV/tYru9WhGbi6IlQEf42EN8b0pNAYblLUZ+fXpOFRI=";
  };

  postPatch = ''
    touch AUTHORS
  '';

  nativeBuildInputs = [
    autoreconfHook
    gtk-doc
    intltool
    itstool
    libtool
    pkg-config
    wrapGAppsHook3
    yelp-tools
  ];

  buildInputs = [
    clutter-gtk
    gstreamer
    gst-plugins-base
    gst-plugins-good
    glib
    gtk3
    libgsf
    libxml2
    # optional packages
    fluidsynth
    gst-plugins-bad
    gst-plugins-ugly
    orc
  ];

  # 'g_memdup' is deprecated: Use 'g_memdup2' instead
  env.NIX_CFLAGS_COMPILE =
    "-Wno-error=deprecated-declarations -Wno-error=incompatible-pointer-types"
    # Suppress incompatible function pointer error in clang due to libxml2 2.12 const changes
    + lib.optionalString stdenv.cc.isClang " -Wno-error=incompatible-function-pointer-types";

  meta = {
    description = "Modular music composer for Linux";
    homepage = "https://www.buzztrax.org/";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ lib.maintainers.bendlas ];
    platforms = lib.platforms.unix;
  };
}
