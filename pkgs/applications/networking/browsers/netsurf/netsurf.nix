args: with args;
stdenv.mkDerivation {

  name = "netsurf-devel";
  src = sourceByName "netsurf";

  # name = "netsurf-2.1";
  /*
  src = fetchurl {
    url = http://www.netsurf-browser.org/downloads/releases/netsurf-2.1-src.tar.gz;
    sha256 = "10as2skm0pklx8bb8s0z2hh72f17snavkhj7dhi8r4sjr10wz8nd";
  };
  */

  buildInputs = [pkgconfig
    libnsbmp libnsgif libwapcaplet libsvgtiny hubub libParserUtils
    curl libpng libxml2 lcms glib libharu libmng
    gtk libglade libCSS];

  buildPhase = "make PREFIX=$out";
  installPhase = "make PREFIX=$out install";

  meta = { 
    description = "free, open source web browser";
    homepage = http://www.netsurf-browser.org;
    license = ["GPLv2" /* visual worrk : */ "MIT" ];
    maintainers = [args.lib.maintainers.marcweber];
    platforms = args.lib.platforms.linux;
  };

}

