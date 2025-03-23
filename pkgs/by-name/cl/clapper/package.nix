{
  lib,
  stdenv,
  fetchFromGitHub,
  gobject-introspection,
  pkg-config,
  ninja,
  desktop-file-utils,
  makeWrapper,
  shared-mime-info,
  wrapGAppsHook4,
  meson,
  gtk4,
  gst_all_1,
  libGL,
  libadwaita,
  libsoup_3,
  vala,
  cmake,
  libmicrodns,
  gtuber,
  glib-networking,
  libpeas2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clapper";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "Rafostar";
    repo = "clapper";
    tag = finalAttrs.version;
    hash = "sha256-Yb2fWsdd8jhxkGWKanLn7CAuF4MjyQ27XTrO8ja3hfs=";
  };

  nativeBuildInputs = [
    gobject-introspection
    meson
    cmake
    ninja
    makeWrapper
    pkg-config
    wrapGAppsHook4 # for gsettings
    desktop-file-utils # for update-desktop-database
    shared-mime-info # for update-mime-database
    vala
  ];

  buildInputs = [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gtuber
    glib-networking # for TLS support
    gtk4
    libGL
    libadwaita
    libsoup_3
    libmicrodns
    libpeas2
  ];

  postPatch = ''
    patchShebangs --build build-aux/meson/postinstall.py
  '';

  # The package uses "clappersink" provided by itself
  preFixup = ''
    gappsWrapperArgs+=(
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : $out/lib/gstreamer-1.0
    )
  '';

  meta = {
    description = "GNOME media player built using GTK4 toolkit and powered by GStreamer with OpenGL rendering";
    longDescription = ''
      Clapper is a GNOME media player built using the GTK4 toolkit.
      The media player is using GStreamer as a media backend.
    '';
    homepage = "https://github.com/Rafostar/clapper";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
})
