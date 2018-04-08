{ fetchurl, stdenv, meson, ninja, gtk3, libexif, libgphoto2, libsoup, libxml2, vala, sqlite
, webkitgtk, pkgconfig, gnome3, gst_all_1, libgudev, libraw, glib, json-glib
, gettext, desktop-file-utils, gdk_pixbuf, librsvg, wrapGAppsHook
, gobjectIntrospection, itstool, libgdata }:

# for dependencies see https://wiki.gnome.org/Apps/Shotwell/BuildingAndInstalling

let
  pname = "shotwell";
  version = "0.28.1";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1ywikm5kdsr7q8hklh146x28rzvqkqfjs8kdpw7zcc15ri0dkzya";
  };

  nativeBuildInputs = [
    meson ninja vala pkgconfig itstool gettext desktop-file-utils wrapGAppsHook gobjectIntrospection
  ];

  buildInputs = [
    gtk3 libexif libgphoto2 libsoup libxml2 sqlite webkitgtk
    gst_all_1.gstreamer gst_all_1.gst-plugins-base gnome3.libgee
    libgudev gnome3.gexiv2 gnome3.gsettings-desktop-schemas
    libraw json-glib glib gdk_pixbuf librsvg gnome3.rest
    gnome3.gcr gnome3.defaultIconTheme libgdata
  ];

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
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
