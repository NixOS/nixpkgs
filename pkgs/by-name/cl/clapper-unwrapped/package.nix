{
  lib,
  stdenv,
  fetchFromGitHub,
  gobject-introspection,
  pkg-config,
  ninja,
  desktop-file-utils,
  shared-mime-info,
  meson,
  gtk4,
  gst_all_1,
  libGL,
  libadwaita,
  libsoup_3,
  vala,
  cmake,
  libmicrodns,
  glib-networking,
  libpeas2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clapper-unwrapped";
  version = "0.8.0";

  outputs = [
    "out"
    "lib"
    "dev"
  ];

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
    pkg-config
    desktop-file-utils # for update-desktop-database
    gtk4 # for gtk4-update-icon-cache
    shared-mime-info # for update-mime-database
    vala
  ];

  buildInputs = [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
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

  preFixup = ''
    mkdir -p $out/share/gsettings-schemas
    # alias clapper-unwrapped schemas to also provide clapper schemas.
    # the precise schema patch can vary based on host platform.
    schemas=$(basename $lib/share/gsettings-schemas/clapper-unwrapped-*)
    cp -r $lib/share/gsettings-schemas/$schemas $out/share/gsettings-schemas/''${schemas/clapper-unwrapped-/clapper-}
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
