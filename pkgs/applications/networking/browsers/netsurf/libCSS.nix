args: with args;
stdenv.mkDerivation {
  name = "libCSS-devel";

  src = sourceByName "libCSS";

  installPhase = "make PREFIX=$out install";
  buildInputs = [pkgconfig libParserUtils libwapcaplet];

  meta = { 
    description = "libCSS is a CSS parser and selection engine, written in C"; # used by netsurf
    homepage = http://www.netsurf-browser.org/projects/libcss/;
    license = "MIT";
    maintainers = [args.lib.maintainers.marcweber];
    platforms = args.lib.platforms.linux;
  };
}
