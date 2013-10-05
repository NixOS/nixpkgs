{stdenv, fetchurl, gettext, ncurses
, gtkGUI ? false
, pkgconfig ? null
, gtk ? null}:

assert gtkGUI -> pkgconfig != null && gtk != null;

stdenv.mkDerivation rec {
  name = "aumix-2.9.1";
  src = fetchurl {
    url = "http://www.jpj.net/~trevor/aumix/releases/${name}.tar.bz2";
    sha256 = "0a8fwyxnc5qdxff8sl2sfsbnvgh6pkij4yafiln0fxgg6bal7knj";
  };

  buildInputs = [ gettext ncurses ]
    ++ (if gtkGUI then [pkgconfig gtk] else []);

  meta = {
    description = "Audio mixer for X and the console";
    longDescription = ''
      Aumix adjusts an audio mixer from X, the console, a terminal,
      the command line or a script.
    '';
    homepage = http://www.jpj.net/~trevor/aumix.html;
    license = "GPLv2+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.linux;
  };
}
