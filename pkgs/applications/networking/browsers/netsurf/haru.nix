args: with args;
stdenv.mkDerivation {

  name = "netsurf-haru-trunk";

  src = sourceByName "netsurf_haru";

  preConfigure = "cd upstream";
  configureFlags = "--with-zlib=${zlib} --with-png=${libpng}";

  buildInputs = [zlib libpng];

  installPhase = "make PREFIX=$out install";

  meta = { 
    description = "cross platform, open source library for generating PDF files";
    homepage = http://libharu.org/wiki/Main_Page;
    license = "ZLIB/LIBPNG"; # see README.
    maintainers = [args.lib.maintainers.marcweber];
    platforms = args.lib.platforms.linux;
  };
}
