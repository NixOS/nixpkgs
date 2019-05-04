{ stdenv,  fetchurl, gnome3, itstool, libxml2, pkgconfig, intltool,
  exiv2, libjpeg, libtiff, gst_all_1, libraw, libsoup, libsecret,
  glib, gtk3, gsettings-desktop-schemas,
  libchamplain, librsvg, libwebp, json-glib, webkitgtk, lcms2, bison,
  flex, wrapGAppsHook, shared-mime-info }:

stdenv.mkDerivation rec {
  pname = "gthumb";
  version = "3.6.2";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0rjb0bsjhn7nyl5jyjgrypvr6qdr9dc2g586j3lzan96a2vnpgy9";
  };

  nativeBuildInputs = [ itstool libxml2 intltool pkgconfig bison flex wrapGAppsHook ];

  buildInputs = [
    glib gtk3 gsettings-desktop-schemas gst_all_1.gstreamer gst_all_1.gst-plugins-base
    exiv2 libjpeg libtiff libraw libsoup libsecret libchamplain
    librsvg libwebp json-glib webkitgtk lcms2 gnome3.adwaita-icon-theme
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--enable-libchamplain"
  ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "${shared-mime-info}/share")
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Apps/Gthumb";
    description = "Image browser and viewer for GNOME";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = [ maintainers.mimadrid ];
  };
}
