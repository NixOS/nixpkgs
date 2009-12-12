args: with args;
stdenv.mkDerivation {
  name = "libCSS-devel";

  # REGION AUTO UPDATE:       { name="libCSS"; type = "svn"; url = "svn://svn.netsurf-browser.org/trunk/libcss"; groups = "netsurf_group"; }
  src= sourceFromHead "libCSS-9721.tar.gz"
               (fetchurl { url = "http://mawercer.de/~nix/repos/libCSS-9721.tar.gz"; sha256 = "47b44653f7b53c21da6224ffb1f81df934cc711d6a5795c5584755a8bd48e5ac"; });
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
