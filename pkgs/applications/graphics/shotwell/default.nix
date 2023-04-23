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
, webkitgtk_4_1
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
, python3
}:

# for dependencies see https://wiki.gnome.org/Apps/Shotwell/BuildingAndInstalling

stdenv.mkDerivation rec {
  pname = "shotwell";
  version = "0.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-F3Ky+h56VHnVKAKLyaMD8oVeHZWaWzyReSLmOpipCxk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    itstool
    gettext
    desktop-file-utils
    python3
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
    webkitgtk_4_1
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

  postPatch = ''
    chmod +x build-aux/meson/postinstall.py # patchShebangs requires executable file
    patchShebangs build-aux/meson/postinstall.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Popular photo organizer for the GNOME desktop";
    homepage = "https://wiki.gnome.org/Apps/Shotwell";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [];
    platforms = platforms.linux;
  };
}
