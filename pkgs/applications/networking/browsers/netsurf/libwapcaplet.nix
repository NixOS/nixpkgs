args: with args;
stdenv.mkDerivation {
  name = "libwapcaplet-devel";

  # REGION AUTO UPDATE:     { name="libwapcaplet"; type = "svn"; url = "svn://svn.netsurf-browser.org/trunk/libwapcaplet"; groups = "netsurf_group"; }
  src= sourceFromHead "libwapcaplet-9721.tar.gz"
               (fetchurl { url = "http://mawercer.de/~nix/repos/libwapcaplet-9721.tar.gz"; sha256 = "7f9f32ca772c939d67f3bc8bf0705544c2b2950760da3fe6a4e069ad0f77d91a"; });
  # END

  installPhase = "make PREFIX=$out install";
  buildInputs = [];

  meta = { 
    description = "LibWapcaplet is a string internment library, written in C";
    homepage = http://www.netsurf-browser.org/projects/libwapcaplet/;
    license = stdenv.lib.licenses.mit;
    maintainers = [args.lib.maintainers.marcweber];
    platforms = args.lib.platforms.linux;
  };
}
