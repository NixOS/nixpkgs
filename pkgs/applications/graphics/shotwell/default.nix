{ fetchurl, stdenv, m4, glibc, gtk3, libexif, libgphoto2, libsoup, libxml2, vala, sqlite
, webkitgtk24x, pkgconfig, gnome3, gst_all_1, which, udev, libraw, glib, json_glib
, gettext, desktop_file_utils, lcms2, gdk_pixbuf, librsvg, makeWrapper
, gnome_doc_utils, hicolor_icon_theme }:

# for dependencies see http://www.yorba.org/projects/shotwell/install/

stdenv.mkDerivation rec {
  version = "0.20.2";
  name = "shotwell-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/shotwell/0.20/${name}.tar.xz";
    sha256 = "0h5pdczsrkplvlvq54zk3am4kjmfpd6pn2sz0ky8lfq1fngwiqip";
  };

  NIX_CFLAGS_COMPILE = "-I${glib}/include/glib-2.0 -I${glib}/lib/glib-2.0/include";

  configureFlags = [ "--disable-gsettings-convert-install" ];

  preConfigure = ''
    patchShebangs .
  '';

  postInstall = ''
    mkdir -p $out/share/gsettings-schemas/$name
    mv $out/share/glib-2.0 $out/share/gsettings-schemas/$name/
  '';

  preFixup = ''
    wrapProgram "$out/bin/shotwell" \
     --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
     --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:${gtk3.out}/share:$out/share:$GSETTINGS_SCHEMAS_PATH" \
     --prefix GIO_EXTRA_MODULES : "${gnome3.dconf}/lib/gio/modules"
  '';


  buildInputs = [ m4 glibc gtk3 libexif libgphoto2 libsoup libxml2 vala sqlite webkitgtk24x
                  pkgconfig gst_all_1.gstreamer gst_all_1.gst-plugins-base gnome3.libgee
                  which udev gnome3.gexiv2 hicolor_icon_theme
                  libraw json_glib gettext desktop_file_utils glib lcms2 gdk_pixbuf librsvg
                  makeWrapper gnome_doc_utils gnome3.rest
                  gnome3.defaultIconTheme ];

  meta = with stdenv.lib; {
    description = "Popular photo organizer for the GNOME desktop";
    homepage = http://www.yorba.org/projects/shotwell/;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [iElectric];
    platforms = platforms.linux;
  };
}
