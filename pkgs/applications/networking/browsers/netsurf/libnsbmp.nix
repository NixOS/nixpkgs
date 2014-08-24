args: with args;
stdenv.mkDerivation {
  name = "libnsbmp-0.0.1";

  src = fetchurl {
    url = http://www.netsurf-browser.org/projects/releases/libnsbmp-0.0.1-src.tar.gz;
    sha256 = "1ldng20w5f725rhfns3v58x1mh3d93zwrx4c8f88rsm6wym14ka2";
  };

  installPhase = "make PREFIX=$out install";
  buildInputs = [];

  meta = { 
    description = "Libnsbmp is a decoding library for BMP and ICO image file formats"; # used by netsurf
    homepage = http://www.netsurf-browser.org/projects/libnsbmp/;
    license = stdenv.lib.licenses.mit;
    maintainers = [args.lib.maintainers.marcweber];
    platforms = args.lib.platforms.linux;
    broken = true;
  };
}
