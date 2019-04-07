{ stdenv
, fetchurl
, fetchpatch
, meson
, ninja
, gtk3
, libexif
, libgphoto2
, libwebp
, libsoup
, libxml2
, vala
, sqlite
, webkitgtk
, pkgconfig
, gnome3
, gst_all_1
, libgudev
, libraw
, glib
, json-glib
, gcr
, libgee
, gexiv2
, librest
, gettext
, desktop-file-utils
, gdk_pixbuf
, librsvg
, wrapGAppsHook
, gobject-introspection
, itstool
, libgdata
, libchamplain
, python3
}:

# for dependencies see https://wiki.gnome.org/Apps/Shotwell/BuildingAndInstalling

stdenv.mkDerivation rec {
  pname = "shotwell";
  version = "0.31.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1pwq953wl7h9cvw7rvlr6pcbq9w28kkr7ddb8x2si81ngp0imwyx";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkgconfig
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
    libsoup
    libxml2
    sqlite
    webkitgtk
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    libgee
    libgudev
    gexiv2
    gnome3.gsettings-desktop-schemas
    libraw
    json-glib
    glib
    gdk_pixbuf
    librsvg
    librest
    gcr
    gnome3.adwaita-icon-theme
    libgdata
    libchamplain
  ];

  postPatch = ''
    chmod +x build-aux/meson/postinstall.py # patchShebangs requires executable file
    patchShebangs build-aux/meson/postinstall.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with stdenv.lib; {
    description = "Popular photo organizer for the GNOME desktop";
    homepage = https://wiki.gnome.org/Apps/Shotwell;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [domenkozar];
    platforms = platforms.linux;
  };
}
