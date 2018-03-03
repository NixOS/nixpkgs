{ fetchurl, stdenv, meson, ninja, gtk3, libexif, libgphoto2, libsoup, libxml2, vala, sqlite
, webkitgtk, pkgconfig, gnome3, gst_all_1, libgudev, libraw, glib, json-glib
, gettext, desktop-file-utils, gdk_pixbuf, librsvg, wrapGAppsHook
, itstool, libgdata }:

# for dependencies see https://wiki.gnome.org/Apps/Shotwell/BuildingAndInstalling

stdenv.mkDerivation rec {
  version = "${major}.${minor}";
  major = "0.27";
  minor = "2";
  name = "shotwell-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/shotwell/${major}/${name}.tar.xz";
    sha256 = "0bxc15gk2306fvxg6bg1s6c706yd89i66ldng0z102mcfi98warb";
  };

  nativeBuildInputs = [
    meson ninja pkgconfig itstool gettext desktop-file-utils wrapGAppsHook
  ];

  buildInputs = [
    gtk3 libexif libgphoto2 libsoup libxml2 vala sqlite webkitgtk
    gst_all_1.gstreamer gst_all_1.gst-plugins-base gnome3.libgee
    libgudev gnome3.gexiv2 gnome3.gsettings-desktop-schemas
    libraw json-glib glib gdk_pixbuf librsvg gnome3.rest
    gnome3.gcr gnome3.defaultIconTheme libgdata
  ];

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  meta = with stdenv.lib; {
    description = "Popular photo organizer for the GNOME desktop";
    homepage = https://wiki.gnome.org/Apps/Shotwell;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [domenkozar];
    platforms = platforms.linux;
  };
}
