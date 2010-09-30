{ stdenv, fetchurl, ncurses, gettext, pkgconfig }:

stdenv.mkDerivation rec {
  name = "vim-7.3";
 
  src = fetchurl {
    url = "ftp://ftp.vim.org/pub/vim/unix/${name}.tar.bz2";
    sha256 = "079201qk8g9yisrrb0dn52ch96z3lzw6z473dydw9fzi0xp5spaw";
  };
 
  buildInputs = [ ncurses gettext pkgconfig ];

  configureFlags = [
    "--enable-multibyte"
    "--enable-nls"
  ];

  postInstall = "ln -s $out/bin/vim $out/bin/vi";
  
  meta = {
    description = "The most popular clone of the VI editor";
    homepage = http://www.vim.org;
  };
}
