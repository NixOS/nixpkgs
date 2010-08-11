{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "vim-7.2";
 
  src = fetchurl {
    url = "ftp://ftp.vim.org/pub/vim/unix/${name}.tar.bz2";
    sha256 = "11hxkb6r2550c4n13nwr0d8afvh30qjyr5c2hw16zgay43rb0kci";
  };
 
  buildInputs = [ ncurses ];

  postInstall = "ln -s $out/bin/vim $out/bin/vi";

  crossAttrs = {
    configureFlags = [
      "vim_cv_toupper_broken=no"
      "--with-tlib=ncurses"
      "vim_cv_terminfo=yes"
      "vim_cv_tty_group=tty"
      "vim_cv_tty_mode=0660"
      "vim_cv_getcwd_broken=no"
      "vim_cv_stat_ignores_slash=yes"
      "ac_cv_sizeof_int=4"
      "vim_cv_memmove_handles_overlap=yes"
      "STRIP=${stdenv.cross.config}-strip"
    ];
  };
  
  meta = {
    description = "The most popular clone of the VI editor";
    homepage = http://www.vim.org;
  };
}
