{lib, stdenv, fetchurl, gettext, ncurses
, gtkGUI ? false
, pkg-config ? null
, gtk2 ? null}:

assert gtkGUI -> pkg-config != null && gtk2 != null;

stdenv.mkDerivation rec {
  name = "aumix-2.9.1";
  src = fetchurl {
    url = "http://www.jpj.net/~trevor/aumix/releases/${name}.tar.bz2";
    sha256 = "0a8fwyxnc5qdxff8sl2sfsbnvgh6pkij4yafiln0fxgg6bal7knj";
  };

  buildInputs = [ gettext ncurses ]
    ++ (if gtkGUI then [pkg-config gtk2] else []);

  meta = {
    description = "Audio mixer for X and the console";
    longDescription = ''
      Aumix adjusts an audio mixer from X, the console, a terminal,
      the command line or a script.
    '';
    homepage = "http://www.jpj.net/~trevor/aumix.html";
    license = lib.licenses.gpl2Plus;

    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
