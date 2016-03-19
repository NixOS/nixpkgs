{ stdenv, fetchFromGitHub, fetchurl, ncurses, gettext, pkgconfig
# default vimrc
, vimrc ? fetchurl {
    name = "default-vimrc";
    url = https://projects.archlinux.org/svntogit/packages.git/plain/trunk/archlinux.vim?h=packages/vim?id=68f6d131750aa778807119e03eed70286a17b1cb;
    sha256 = "18ifhv5q9prd175q3vxbqf6qyvkk6bc7d2lhqdk0q78i68kv9y0c";
  }
# apple frameworks
, Carbon, Cocoa }:

stdenv.mkDerivation rec {
  name = "vim-${version}";
  version = "7.4.1585";

  src = fetchFromGitHub {
    owner = "vim";
    repo = "vim";
    rev = "v${version}";
    sha256 = "1kjdwpka269i4cyl0rmnmzg23dl26g65k26h32w8ayzfm3kbj123";
  };

  enableParallelBuilding = true;

  buildInputs = [ ncurses pkgconfig ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ Carbon Cocoa ];
  nativeBuildInputs = [ gettext ];

  configureFlags = [
    "--enable-multibyte"
    "--enable-nls"
  ];

  hardeningDisable = [ "fortify" ];

  postInstall = ''
    ln -s $out/bin/vim $out/bin/vi
    mkdir -p $out/share/vim
    cp "${vimrc}" $out/share/vim/vimrc
  '';

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

  __impureHostDeps = [ "/dev/ptmx" ];

  # To fix the trouble in vim73, that it cannot cross-build with this patch
  # to bypass a configure script check that cannot be done cross-building.
  # http://groups.google.com/group/vim_dev/browse_thread/thread/66c02efd1523554b?pli=1
  # patchPhase = ''
  #   sed -i -e 's/as_fn_error.*int32.*/:/' src/auto/configure
  # '';

  meta = with stdenv.lib; {
    description = "The most popular clone of the VI editor";
    homepage    = http://www.vim.org;
    license = licenses.vim;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
