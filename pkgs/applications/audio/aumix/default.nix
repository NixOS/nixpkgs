{stdenv, fetchurl, gettext, ncurses
, gtkGUI ? false
, pkgconfig ? null
, gtk ? null}:

assert gtkGUI -> pkgconfig != null && gtk != null;

stdenv.mkDerivation {
  name = "aumix-2.8";
  src = fetchurl {
    url = http://www.jpj.net/~trevor/aumix/aumix-2.8.tar.bz2;
    sha256 = "636eef7f400c2f3df489c0d2fa21507e88692113561e75a40a26c52bc422d7fc";
  };

  buildInputs = [ gettext ncurses ]
    ++ (if gtkGUI then [pkgconfig gtk] else []);

  meta = {
    longDescription = ''
      Aumix adjusts an audio mixer from X, the console, a terminal,
      the command line or a script.
    '';
    homepage = http://www.jpj.net/~trevor/aumix.html;
    license = "GPL";
  };
}
