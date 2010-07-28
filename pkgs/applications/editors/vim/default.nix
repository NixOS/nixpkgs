{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "vim-7.2";
 
  src = fetchurl {
    url = "ftp://ftp.vim.org/pub/vim/unix/${name}.tar.bz2";
    sha256 = "11hxkb6r2550c4n13nwr0d8afvh30qjyr5c2hw16zgay43rb0kci";
  };
 
  buildInputs = [ ncurses ];

  postInstall = "ln -s $out/bin/vim $out/bin/vi";
  
  meta = {
    description = "The most popular clone of the VI editor";
    homepage = http://www.vim.org;
  };
}
