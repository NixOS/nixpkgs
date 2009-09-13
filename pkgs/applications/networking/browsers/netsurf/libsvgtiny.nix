args: with args;
stdenv.mkDerivation {
  name = "libsvgtiny-devel";

  src = sourceByName "libsvgtiny";

  installPhase = "make PREFIX=$out install";
  buildInputs = [pkgconfig gperf libxml2];

  meta = { 
    description = "implementation of SVG Tiny, written in C";
    homepage = http://www.netsurf-browser.org/projects/libsvgtiny/;
    license = "MIT";
    maintainers = [args.lib.maintainers.marcweber];
    platforms = args.lib.platforms.linux;
  };
}
