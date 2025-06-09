{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  vala,
  glib,
  libsoup_3,
  json-glib,
  libxml2,
  gst_all_1,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "gtuber";
  version = "0-unstable-2025-01-19";

  src = fetchFromGitHub {
    owner = "Rafostar";
    repo = "gtuber";
    rev = "446e26668a4e01fc2ca9c261a7f1c281577e566d";
    hash = "sha256-5Z6sID7Alm4FWl1qCQV1w5DmGsmor2vbnZUJi3Is650=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection # For g-ir-scanner
    vala # For vapigen
  ];
  buildInputs = [
    glib
    libsoup_3
    json-glib
    libxml2
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
  ];

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = {
    description = "GStreamer plugin for streaming videos from websites";
    homepage = "https://rafostar.github.io/gtuber/";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ chuangzhu ];
    platforms = lib.platforms.unix;
  };
}
