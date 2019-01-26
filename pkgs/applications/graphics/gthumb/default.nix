{ stdenv,  fetchurl, gnome3, itstool, libxml2, pkgconfig, intltool,
  exiv2, libjpeg, libtiff, gst_all_1, libraw, libsoup, libsecret,
  libchamplain, librsvg, libwebp, json-glib, webkitgtk, lcms2, bison,
  flex, wrapGAppsHook, shared-mime-info }:

let
  pname = "gthumb";
  version = "3.6.2";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0rjb0bsjhn7nyl5jyjgrypvr6qdr9dc2g586j3lzan96a2vnpgy9";
  };

  nativeBuildInputs = [ itstool libxml2 intltool pkgconfig bison flex wrapGAppsHook ];

  buildInputs = with gnome3; [
    glib gtk gsettings-desktop-schemas gst_all_1.gstreamer gst_all_1.gst-plugins-base
    exiv2 libjpeg libtiff libraw libsoup libsecret libchamplain
    librsvg libwebp json-glib webkitgtk lcms2 defaultIconTheme
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
    homepage = https://wiki.gnome.org/Apps/gthumb;
    description = "Image browser and viewer for GNOME";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = [ maintainers.mimadrid ];
  };
}
