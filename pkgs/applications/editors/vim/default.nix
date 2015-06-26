{ stdenv, fetchhg, ncurses, gettext, pkgconfig

# apple frameworks
, CoreServices, CoreData, Cocoa, Foundation, libobjc }:

stdenv.mkDerivation rec {
  name = "vim-${version}";

  version = "7.4.683";

  src = fetchhg {
    url = "https://code.google.com/p/vim/";
    rev = "v7-4-663";
    sha256 = "1z0qarf6a2smab28g9dnxklhfayn85wx48bnddmyhb9kqzjgqgjc";
  };

  enableParallelBuilding = true;

  buildInputs = [ ncurses pkgconfig ]
    ++ stdenv.lib.optional stdenv.isDarwin [ CoreData CoreServices Cocoa Foundation libobjc ];
  nativeBuildInputs = [ gettext ];

  __impureHostDeps = import ./impure-deps.nix;

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

  meta = with stdenv.lib; {
    description = "The most popular clone of the VI editor";
    homepage    = http://www.vim.org;
    license = licenses.vim;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
