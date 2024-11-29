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
  version = "0-unstable-2024-10-11";

  src = fetchFromGitHub {
    owner = "Rafostar";
    repo = "gtuber";
    rev = "468bf02a8adcf69b1bd6dd7b5dbcdcc0bfdb6922";
    hash = "sha256-pEiHqcxkrxZRD9xW/R9DNDdp5foxaHK2SAuzmPNegaY=";
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
