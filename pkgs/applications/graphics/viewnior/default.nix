{ stdenv, fetchurl, pkgconfig, gtk2, libpng, exiv2, lcms
, intltool, gettext, shared_mime_info, glib, gdk_pixbuf, perl}:

stdenv.mkDerivation rec {
  name = "viewnior-1.3";

  src = fetchurl {
    url = "http://cloud.github.com/downloads/xsisqox/Viewnior/${name}.tar.gz";
    sha256 = "46c97c1a85361519b42fe008cfb8911e66f709f3a3a988c11047ab3726889f10";
  };

  buildInputs =
    [ pkgconfig gtk2 libpng exiv2 lcms intltool gettext
      shared_mime_info glib gdk_pixbuf perl
    ];

  meta = {
    description = "Viewnior is a fast and simple image viewer for GNU/Linux";
    longDescription =
      '' Viewnior is insipred by big projects like Eye of Gnome, because of it's
         usability and richness,and by GPicView, because of it's lightweight design and
         minimal interface. So here comes Viewnior - small and light, with no compromise
         with the quality of it's functions. The program is made with better integration
         in mind (follows Gnome HIG2).
      '';

    license = "GPLv3";

    homepage = http://xsisqox.github.com/Viewnior;

    maintainers = [ stdenv.lib.maintainers.smironov ];

    platforms = stdenv.lib.platforms.gnu;
  };
}
