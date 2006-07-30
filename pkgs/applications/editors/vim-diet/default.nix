{stdenv, fetchurl, ncurses, dietgcc}:
 
stdenv.mkDerivation {
  name = "vim-7.0";
 
  src = fetchurl {
    url = ftp://ftp.vim.org/pub/vim/unix/vim-7.0.tar.bz2;
    md5 = "4ca69757678272f718b1041c810d82d8";
  };
 
  inherit ncurses;
  buildInputs = [ncurses];

  NIX_GCC = dietgcc;
  NIX_GLIBC_FLAGS_SET=1;
  NIX_CFLAGS_COMPILE="-D_BSD_SOURCE=1";
}
