{ lib
, stdenv
, fetchurl
, meson
, ninja
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
, wrapGAppsHook
, gobject-introspection
, itstool
, libsecret
, libportal-gtk3
, gsettings-desktop-schemas
}:

# for dependencies see https://wiki.gnome.org/Apps/Shotwell/BuildingAndInstalling

stdenv.mkDerivation (finalAttrs: {
  pname = "shotwell";
  version = "0.32.6";

  src = fetchurl {
    url = "mirror://gnome/sources/shotwell/${lib.versions.majorMinor finalAttrs.version}/shotwell-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-dZek/6yR4YzYFEsS8tCDE6P0Bbs2gkOnMmgm99kqcLY=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    itstool
    gettext
    desktop-file-utils
    wrapGAppsHook
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
    gnome.adwaita-icon-theme
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
    homepage = "https://wiki.gnome.org/Apps/Shotwell";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [];
    platforms = platforms.linux;
  };
})
