{ stdenv
, fetchurl
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
, libgdata
, libchamplain
, gsettings-desktop-schemas
, python3
}:

# for dependencies see https://wiki.gnome.org/Apps/Shotwell/BuildingAndInstalling

stdenv.mkDerivation rec {
  pname = "shotwell";
  version = "0.31.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0mbgrad4d4snffw2z3rkhwqq1bkxdgy52pblx99vjadvpgspb034";
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
    gsettings-desktop-schemas
    libraw
    json-glib
    glib
    glib-networking
    gdk-pixbuf
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
    homepage = "https://wiki.gnome.org/Apps/Shotwell";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [domenkozar];
    platforms = platforms.linux;
  };
}
