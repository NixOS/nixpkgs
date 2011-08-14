{ stdenv, fetchurl, pkgconfig, gdk_pixbuf, gtk, libXmu }:

stdenv.mkDerivation rec {
  name = "trayer-1.1.3";

  buildInputs = [ pkgconfig gdk_pixbuf gtk libXmu ];

  src = fetchurl {
          url = "https://github.com/sargon/trayer-srg/tarball/${name}";
          name = "${name}.tar.gz";
          sha256 = "03be5ea47278ecdb6ffb1d3b5115a855a6eccd6aa6702b84e89ee047ddd76558";
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

