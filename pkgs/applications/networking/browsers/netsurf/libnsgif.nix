args: with args;
stdenv.mkDerivation {
  name = "libnsgif-0.0.1";

  src = fetchurl {
    url = http://www.netsurf-browser.org/projects/releases/libnsgif-0.0.1-src.tar.gz;
    sha256 = "0lnvyhfdb9dm979fly33mi2jlf2rfx9ldx93viawvana63sidwsl";
  };

  installPhase = "make PREFIX=$out install";
  buildInputs = [];

  meta = {
    description = "Libnsbmp is a decoding library for gif image file formats"; # used by netsurf
    homepage = http://www.netsurf-browser.org/projects/libnsgif/;
    license = stdenv.lib.licenses.mit;
    maintainers = [args.lib.maintainers.marcweber];
    platforms = args.lib.platforms.linux;
    broken = true;
  };
}
