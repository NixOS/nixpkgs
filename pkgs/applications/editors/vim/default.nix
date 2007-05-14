{stdenv, fetchurl, ncurses}:
 
stdenv.mkDerivation {
  name = "vim-7.1";
 
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/editors/vim/unix/vim-7.1.tar.bz2;
    sha256 = "0w6gy49gdbw7hby5rjkjpa7cdvc0z5iajsm4j1h8108rvfam22kz";
  };
 
  inherit ncurses;
  buildInputs = [ncurses];

  meta = {
    description = "The most popular clone of the VI editor";
  };
}
