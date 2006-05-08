{stdenv, fetchurl, ncurses}:
 
stdenv.mkDerivation {
  name = "vim-7.0";
 
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.vim.org/pub/vim/unix/vim-7.0.tar.bz2;
    md5 = "4ca69757678272f718b1041c810d82d8";
  };
 
  inherit ncurses;
  buildInputs = [ncurses];
}
