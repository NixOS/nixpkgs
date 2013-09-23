{ stdenv, fetchurl, ncurses, gettext, pkgconfig }:

stdenv.mkDerivation rec {
  patchLevel = "23";
  name       = "vim-7.4.${patchLevel}";
 
  src = fetchurl {
    url    = "ftp://ftp.vim.org/pub/vim/unix/${name}.tar.bz2";
    sha256 = "1pjaffap91l2rb9pjnlbrpvb3ay5yhhr3g91zabjvw1rqk9adxfh";
  };

  enableParallelBuilding = true;
 
  buildInputs = [ ncurses pkgconfig ];
  nativeBuildInputs = [ gettext ];

  configureFlags = [
    "--enable-multibyte"
    "--enable-nls"
  ];

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
      "vim_cv_memmove_handles_overlap=yes"
      "STRIP=${stdenv.cross.config}-strip"
    ];
  };

  # To fix the trouble in vim73, that it cannot cross-build with this patch
  # to bypass a configure script check that cannot be done cross-building.
  # http://groups.google.com/group/vim_dev/browse_thread/thread/66c02efd1523554b?pli=1
  # patchPhase = ''
  #   sed -i -e 's/as_fn_error.*int32.*/:/' src/auto/configure
  # '';

  prePatch = "cd src";
  
  patches =
    [ ./patches/7.4.001 ./patches/7.4.002 ./patches/7.4.003 ./patches/7.4.004
      ./patches/7.4.005 ./patches/7.4.006 ./patches/7.4.007 ./patches/7.4.008
      ./patches/7.4.009 ./patches/7.4.010 ./patches/7.4.011 ./patches/7.4.012
      ./patches/7.4.013 ./patches/7.4.014 ./patches/7.4.015 ./patches/7.4.016
      ./patches/7.4.017 ./patches/7.4.018 ./patches/7.4.019 ./patches/7.4.020
      ./patches/7.4.021 ./patches/7.4.022 ./patches/7.4.023 ];

  meta = with stdenv.lib; {
    description = "The most popular clone of the VI editor";
    homepage    = http://www.vim.org;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
