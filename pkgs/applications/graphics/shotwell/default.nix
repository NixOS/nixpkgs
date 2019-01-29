{ fetchurl, stdenv, meson, ninja, gtk3, libexif, libgphoto2, libsoup, libxml2, vala, sqlite
, webkitgtk, pkgconfig, gnome3, gst_all_1, libgudev, libraw, glib, json-glib, gcr
, gettext, desktop-file-utils, gdk_pixbuf, librsvg, wrapGAppsHook
, gobject-introspection, itstool, libgdata, python3 }:

# for dependencies see https://wiki.gnome.org/Apps/Shotwell/BuildingAndInstalling

let
  pname = "shotwell";
  version = "0.30.1";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "01hsmig06hjv34yf9y60hv2gml593xfkza4ilq4b22gr8l4v2qip";
  };

  nativeBuildInputs = [
    meson ninja vala pkgconfig itstool gettext desktop-file-utils python3 wrapGAppsHook gobject-introspection
  ];

  buildInputs = [
    gtk3 libexif libgphoto2 libsoup libxml2 sqlite webkitgtk
    gst_all_1.gstreamer gst_all_1.gst-plugins-base gnome3.libgee
    libgudev gnome3.gexiv2 gnome3.gsettings-desktop-schemas
    libraw json-glib glib gdk_pixbuf librsvg gnome3.rest
    gcr gnome3.defaultIconTheme libgdata
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
