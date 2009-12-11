args: with args;
stdenv.mkDerivation {
  name = "libCSS-devel";

  # REGION AUTO UPDATE:      { name="libCSS"; type = "svn"; url = "svn://svn.netsurf-browser.org/trunk/libcss"; groups = "netsurf_group"; }
  src= sourceFromHead "libCSS-9721.tar.gz"
               (fetchurl { url = "http://mawercer.de/~nix/repos/libCSS-9721.tar.gz"; sha256 = "b6ac015351e78c080b71bbe834eadee0d1cb2c6c4657c338be6cbf0f51d5f8a9"; });
  # END

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
