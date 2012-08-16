{ stdenv, fetchurl, pkgconfig, gdk_pixbuf, gtk, libXmu }:

stdenv.mkDerivation rec {
  name = "trayer-1.1.5";

  buildInputs = [ pkgconfig gdk_pixbuf gtk libXmu ];

  src = fetchurl {
          url = "https://github.com/sargon/trayer-srg/tarball/${name}";
          name = "${name}.tar.gz";
          sha256 = "98804500188c0bb99c7389ebea4b2e4dfffa2f3d06dc97e633b4934cf7c29757";
        };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = http://github.com/sargon/trayer-srg;

    license = "bsd";

    description = "A lightweight GTK2-based systray for UNIX desktop";

    maintainers = [ stdenv.lib.maintainers.shlevy ];

    platforms = stdenv.lib.platforms.linux;
  };
}

