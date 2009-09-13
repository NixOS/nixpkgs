args: with args;
stdenv.mkDerivation {
  name = "libwapcaplet-devel";

  src = sourceByName "libwapcaplet";

  installPhase = "make PREFIX=$out install";
  buildInputs = [];

  meta = { 
    description = "LibWapcaplet is a string internment library, written in C";
    homepage = http://www.netsurf-browser.org/projects/libwapcaplet/;
    license = "MIT";
    maintainers = [args.lib.maintainers.marcweber];
    platforms = args.lib.platforms.linux;
  };
}
