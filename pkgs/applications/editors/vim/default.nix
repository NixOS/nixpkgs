{stdenv, fetchurl, ncurses}:
 
stdenv.mkDerivation {
  name = "vim-6.3";
 
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.vim.org/mirror/vim/unix/vim-6.3.tar.bz2;
    md5 = "821fda8f14d674346b87e3ef9cb96389";
  };
 
  inherit ncurses;
  buildInputs = [ncurses];
}
