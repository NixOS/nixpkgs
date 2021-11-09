{ lib
, stdenv
, fetchurl
, gettext
, ncurses
, gtkGUI ? false
, pkg-config
, gtk2
}:

stdenv.mkDerivation rec {
  pname = "aumix";
  version = "2.9.1";

  src = fetchurl {
    url = "http://www.jpj.net/~trevor/aumix/releases/aumix-${version}.tar.bz2";
    sha256 = "0a8fwyxnc5qdxff8sl2sfsbnvgh6pkij4yafiln0fxgg6bal7knj";
  };

  buildInputs = [ gettext ncurses ]
    ++ lib.optionals gtkGUI [ pkg-config gtk2 ];

  meta = with lib; {
    description = "Audio mixer for X and the console";
    longDescription = ''
      Aumix adjusts an audio mixer from X, the console, a terminal,
      the command line or a script.
    '';
    homepage = "http://www.jpj.net/~trevor/aumix.html";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
