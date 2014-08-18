args: with args;
stdenv.mkDerivation {
  name = "libsvgtiny-devel";

  # REGION AUTO UPDATE:      { name="libsvgtiny"; type = "svn"; url = "svn://svn.netsurf-browser.org/trunk/libsvgtiny"; groups = "netsurf_group"; }
  src= sourceFromHead "libsvgtiny-9721.tar.gz"
               (fetchurl { url = "http://mawercer.de/~nix/repos/libsvgtiny-9721.tar.gz"; sha256 = "0c4c8e357c220218a32ef789eb2ba8226a403d4c2b550d7c65f351a0af5d1a71"; });
  # END

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
