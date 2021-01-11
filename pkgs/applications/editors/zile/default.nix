{ fetchurl, lib, stdenv, glib, libgee, pkg-config, ncurses, boehmgc, perl, help2man, vala }:

stdenv.mkDerivation rec {
  name = "zile-2.6.0.90";

  src = fetchurl {
    url = "mirror://gnu/zile/${name}.tar.gz";
    sha256 = "1bhdwnasmqhy0hi3fqmpzr8xkw5zlqjpmf1cj42h4cg3fnamp6r3";
  };

  buildInputs = [ glib libgee ncurses boehmgc vala ];
  nativeBuildInputs = [ perl pkg-config ]
    # `help2man' wants to run Zile, which won't work when the
    # newly-produced binary can't be run at build-time.
    ++ stdenv.lib.optional
         (stdenv.hostPlatform == stdenv.buildPlatform)
         help2man;

  # Tests can't be run because most of them rely on the ability to
  # fiddle with the terminal.
  doCheck = false;

  # XXX: Work around cross-compilation-unfriendly `gl_FUNC_FSTATAT' macro.
  gl_cv_func_fstatat_zero_flag="yes";

  meta = with lib; {
    description = "Lightweight Emacs clone";

    longDescription = ''
      GNU Zile, which is a lightweight Emacs clone.  Zile is short
      for Zile Is Lossy Emacs.  Zile has been written to be as
      similar as possible to Emacs; every Emacs user should feel at
      home.

      Zile has all of Emacs's basic editing features: it is 8-bit
      clean (though it currently lacks Unicode support), and the
      number of editing buffers and windows is only limited by
      available memory and screen space respectively.  Registers,
      minibuffer completion and auto fill are available.  Function
      and variable names are identical with Emacs's (except those
      containing the word "emacs", which instead contain the word
      "zile"!).

      However, all of this is packed into a program which typically
      compiles to about 130Kb.
    '';

    homepage = "https://www.gnu.org/software/zile/";

    license = licenses.gpl3Plus;

    maintainers = with maintainers; [ pSub ];

    platforms = platforms.unix;
  };
}
