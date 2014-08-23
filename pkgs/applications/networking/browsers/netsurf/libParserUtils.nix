args: with args;
stdenv.mkDerivation {
  name = "libParserUtils-0.0.1";

  src = fetchurl {
    url = http://www.netsurf-browser.org/projects/releases/libparserutils-0.0.1-src.tar.gz;
    sha256 = "0r9ia32kgvcfjy82xyiyihyg9yhh3l9pdzk6sp6d6gh2sbglxvas";
  };

  installPhase = "make PREFIX=$out install";
  buildInputs = [pkgconfig];

  meta = { 
    description = "LibParserUtils is a library for building efficient parsers, written in C";
    homepage = http://www.netsurf-browser.org/projects/libparserutils/;
    license = stdenv.lib.licenses.mit;
    maintainers = [args.lib.maintainers.marcweber];
    platforms = args.lib.platforms.linux;
    broken = true;
  };
}
