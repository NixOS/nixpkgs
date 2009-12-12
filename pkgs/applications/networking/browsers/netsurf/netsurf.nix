args: with args;
stdenv.mkDerivation {

  name = "netsurf-devel";
  # REGION AUTO UPDATE:      { name="netsurf"; type = "svn"; url = "svn://svn.netsurf-browser.org/trunk/netsurf"; groups = "netsurf_group"; }
  src= sourceFromHead "netsurf-9721.tar.gz"
               (fetchurl { url = "http://mawercer.de/~nix/repos/netsurf-9721.tar.gz"; sha256 = "4705f059596fbd95b1a80d9a6c5d08daf051fd0e5e868ccd40b30af8a45e8f56"; });
  # END

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

