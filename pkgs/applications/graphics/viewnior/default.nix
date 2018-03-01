{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, gtk2, libpng, exiv2, lcms
, intltool, gettext, shared-mime-info, glib, gdk_pixbuf, perl}:

stdenv.mkDerivation rec {
  name = "viewnior-${version}";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "xsisqox";
    repo = "Viewnior";
    rev = name;
    sha256 = "06ppv3r85l3id4ij6h4y5fgm3nib2587fdrdv9fccyi75zk7fs0p";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs =
    [ pkgconfig gtk2 libpng exiv2 lcms intltool gettext
      shared-mime-info glib gdk_pixbuf perl
    ];

  preFixup = ''
    rm $out/share/icons/*/icon-theme.cache
  '';

  meta = {
    description = "Fast and simple image viewer";
    longDescription =
      '' Viewnior is insipred by big projects like Eye of Gnome, because of it's
         usability and richness,and by GPicView, because of it's lightweight design and
         minimal interface. So here comes Viewnior - small and light, with no compromise
         with the quality of it's functions. The program is made with better integration
         in mind (follows Gnome HIG2).
      '';

    license = stdenv.lib.licenses.gpl3;

    homepage = http://siyanpanayotov.com/project/viewnior/;

    maintainers = [ stdenv.lib.maintainers.smironov ];

    platforms = stdenv.lib.platforms.gnu;
  };
}
