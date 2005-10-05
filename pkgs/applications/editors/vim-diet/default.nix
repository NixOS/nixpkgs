{stdenv, fetchurl, ncurses, dietgcc}:
 
stdenv.mkDerivation {
  name = "vim-6.3";
 
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/vim-6.3.tar.bz2;
    md5 = "821fda8f14d674346b87e3ef9cb96389";
  };
 
  inherit ncurses;
  buildInputs = [ncurses];

  NIX_GCC = dietgcc;
  NIX_GLIBC_FLAGS_SET=1;
  NIX_CFLAGS_COMPILE="-D_BSD_SOURCE=1";
}
