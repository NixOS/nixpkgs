{ stdenv, fetchurl, pkgconfig, gtk, libpng, exiv2, lcms
, intltool, gettext }:

stdenv.mkDerivation rec {
  name = "geeqie-1.0beta2";

  src = fetchurl {
    url = "mirror://sourceforge/geeqie/${name}.tar.gz";
    sha256 = "13h924iykmxwgpx562lrsh2j78fnzyyfmg4w7qgj9vbjq18nq7fd";
  };

  buildInputs = [ pkgconfig gtk libpng exiv2 lcms intltool gettext ];

  meta = {
    description = "Geeqie, a lightweight GTK+ based image viewe";

    longDescription =
      '' Geeqie is a lightweight Gtk+ based image viewer for Unix like
         operating systems.  It features: EXIF, IPTC and XMP metadata
         browsing and editing interoperability; easy integration with other
         software; geeqie works on files and directories, there is no need to
         import images; fast preview for many raw image formats; tools for
         image comparison, sorting and managing photo collection.  Geeqie was
         initially based on GQview.
      '';

    license = "GPLv2+";

    homepage = http://geeqie.sourceforge.net;

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.gnu;
  };
}
