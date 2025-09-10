{
  lib,
  stdenv,
  gettext,
  fetchurl,
  wrapGAppsHook3,
  gnome-video-effects,
  libcanberra-gtk3,
  pkg-config,
  gtk3,
  glib,
  clutter-gtk,
  clutter-gst,
  gst_all_1,
  itstool,
  vala,
  docbook_xml_dtd_43,
  docbook-xsl-nons,
  appstream-glib,
  libxslt,
  gtk-doc,
  adwaita-icon-theme,
  librsvg,
  totem,
  gdk-pixbuf,
  gnome,
  gnome-desktop,
  libxml2,
  meson,
  ninja,
  dbus,
  pipewire,
}:

stdenv.mkDerivation rec {
  pname = "cheese";
  version = "44.1";

  outputs = [
    "out"
    "man"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/cheese/${lib.versions.major version}/cheese-${version}.tar.xz";
    hash = "sha256-XyGFxMmeVN3yuLr2DIKBmVDlSVLhMuhjmHXz7cv49o4=";
  };

  nativeBuildInputs = [
    appstream-glib
    docbook_xml_dtd_43
    docbook-xsl-nons
    gettext
    gtk-doc
    itstool
    libxml2
    libxslt # for xsltproc
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
    glib # for glib-compile-schemas
  ];

  buildInputs = [
    adwaita-icon-theme
    clutter-gst
    dbus
    gnome-desktop
    gnome-video-effects
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gtk3
    libcanberra-gtk3
    librsvg
    pipewire # PipeWire provides a gstreamer plugin for using PipeWire for video
  ];

  propagatedBuildInputs = [
    clutter-gtk
    gdk-pixbuf
    glib
    gst_all_1.gstreamer
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      # Effects
      --prefix XDG_DATA_DIRS : "${gnome-video-effects}/share"
      # vp8enc preset
      --prefix GST_PRESET_PATH : "${gst_all_1.gst-plugins-good}/share/gstreamer-1.0/presets"
      # Thumbnailers
      --prefix XDG_DATA_DIRS : "${gdk-pixbuf}/share"
      --prefix XDG_DATA_DIRS : "${totem}/share"
    )
  '';

  # Fix GCC 14 build
  # ../libcheese/cheese-flash.c:135:22: error: assignment to 'GtkWidget *' {aka 'struct _GtkWidget *'} from
  # incompatible pointer type 'GObject *' {aka 'struct _GObject *'} [-Wincompatible-pointer-types]
  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "cheese";
    };
  };

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/cheese";
    changelog = "https://gitlab.gnome.org/GNOME/cheese/-/blob/${version}/NEWS?ref_type=tags";
    description = "Take photos and videos with your webcam, with fun graphical effects";
    mainProgram = "cheese";
    maintainers = with lib.maintainers; [ aleksana ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
