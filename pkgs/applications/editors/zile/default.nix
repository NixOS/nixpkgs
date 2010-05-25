{ fetchurl, stdenv, ncurses, help2man }:

stdenv.mkDerivation rec {
  name = "zile-2.3.16";

  src = fetchurl {
    url = "mirror://gnu/zile/${name}.tar.gz";
    sha256 = "1lm24sw2ziqsib11sddz7gcqzw5iwfnsx65m1i461kxq218xl59h";
  };

  buildInputs = [ ncurses ];
  buildNativeInputs = [ help2man ];

  # Tests can't be run because most of them rely on the ability to
  # fiddle with the terminal.
  doCheck = false;

  meta = {
    description = "GNU Zile, a lightweight Emacs clone";

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

    homepage = http://www.gnu.org/software/zile/;

    license = "GPLv3+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
