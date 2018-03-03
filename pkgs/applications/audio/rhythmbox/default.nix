{ stdenv, fetchurl, pkgconfig
, python3
, perl
, perlPackages
, gtk3
, intltool
, libsoup
, gnome3
, tdb
, json-glib
, itstool
, wrapGAppsHook
, gst_all_1
, gst_plugins ? with gst_all_1; [ gst-plugins-good gst-plugins-ugly ]
}:
let
  version = "${major}.${minor}";
  major = "3.2";
  minor = "1";

in stdenv.mkDerivation rec {
  name = "rhythmbox-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/rhythmbox/${major}/${name}.tar.xz";
    sha256 = "0f3radhlji7rxl760yl2vm49fvfslympxrpm8497acbmbd7wlhxz";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    python3
    perl
    perlPackages.XMLParser

    intltool
    libsoup
    tdb
    json-glib
    itstool

    gtk3
    gnome3.libpeas
    gnome3.totem-pl-parser
    gnome3.defaultIconTheme

    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base

    wrapGAppsHook
  ] ++ gst_plugins;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Rhythmbox;
    description = "A music playing application for GNOME";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.rasendubi ];
  };
}
