{ stdenv, fetchurl, pkgconfig, gtk2, libpng, exiv2, lcms
, intltool, gettext, shared_mime_info, glib, gdk_pixbuf, perl}:

stdenv.mkDerivation rec {
  name = "viewnior-1.4";

  src = fetchurl {
    url = "https://www.dropbox.com/s/zytq0suabesv933/${name}.tar.gz";
    sha256 = "0vv1133phgfzm92md6bbccmcvfiqb4kz28z1572c0qj971yz457a";
  };

  buildInputs =
    [ pkgconfig gtk2 libpng exiv2 lcms intltool gettext
      shared_mime_info glib gdk_pixbuf perl
    ];

  preFixup = ''
    rm $out/share/icons/*/icon-theme.cache
  '';

  meta = {
    description = "Viewnior is a fast and simple image viewer for GNU/Linux";
    longDescription =
      '' Viewnior is insipred by big projects like Eye of Gnome, because of it's
         usability and richness,and by GPicView, because of it's lightweight design and
         minimal interface. So here comes Viewnior - small and light, with no compromise
         with the quality of it's functions. The program is made with better integration
         in mind (follows Gnome HIG2).
      '';

    license = stdenv.lib.licenses.gpl3;

    homepage = http://xsisqox.github.com/Viewnior;

    maintainers = [ stdenv.lib.maintainers.smironov ];

    platforms = stdenv.lib.platforms.gnu;
  };
}
