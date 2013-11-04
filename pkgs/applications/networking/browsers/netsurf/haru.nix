args: with args;
stdenv.mkDerivation {

  name = "netsurf-haru-trunk";

  # REGION AUTO UPDATE:     { name="netsurf_haru"; type = "svn"; url = "svn://svn.netsurf-browser.org/trunk/libharu"; groups = "netsurf_group"; }
  src= sourceFromHead "netsurf_haru-9721.tar.gz"
               (fetchurl { url = "http://mawercer.de/~nix/repos/netsurf_haru-9721.tar.gz"; sha256 = "8113492823e1069f428ef8970c2c7a09b4c36c645480ce81f8351331ce097656"; });
  # END

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
    broken = true;
  };
}
