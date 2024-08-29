{ lib
, stdenv
, fetchurl
, meson
, ninja
, adwaita-icon-theme
, gtk3
, libexif
, libgphoto2
, libwebp
, libsoup_3
, libxml2
, vala
, sqlite
, pkg-config
, gnome
, gst_all_1
, libgudev
, libraw
, glib
, glib-networking
, json-glib
, gcr
, libgee
, gexiv2
, librest
, gettext
, desktop-file-utils
, gdk-pixbuf
, librsvg
, wrapGAppsHook3
, gobject-introspection
, itstool
, libsecret
, libportal-gtk3
, gsettings-desktop-schemas
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "shotwell";
  version = "0.32.8";

  src = fetchurl {
    url = "mirror://gnome/sources/shotwell/${lib.versions.majorMinor finalAttrs.version}/shotwell-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-RwY8AXnl2A9TQ3PcVg4c6Ad6rdWE7u8GxSOkYOL5KcM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    itstool
    gettext
    desktop-file-utils
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    libexif
    libgphoto2
    libwebp
    libsoup_3
    libxml2
    sqlite
    gst_all_1.gstreamer
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    libgee
    libgudev
    gexiv2
    gsettings-desktop-schemas
    libraw
    json-glib
    glib
    glib-networking
    gdk-pixbuf
    librsvg
    librest
    gcr
    adwaita-icon-theme
    libsecret
    libportal-gtk3
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "shotwell";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Popular photo organizer for the GNOME desktop";
    mainProgram = "shotwell";
    homepage = "https://gitlab.gnome.org/GNOME/shotwell";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ bobby285271 ];
    platforms = platforms.linux;
  };
})
