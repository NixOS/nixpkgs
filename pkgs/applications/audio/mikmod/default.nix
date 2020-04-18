{ stdenv, fetchurl, libmikmod, ncurses }:

stdenv.mkDerivation rec {
  name = "mikmod-3.2.8";

  src = fetchurl {
    url = "mirror://sourceforge/mikmod/${name}.tar.gz";
    sha256 = "1k54p8pn3jinha0f2i23ad15pf1pamibzcxjrbzjbklpcz1ipc6v";
  };

  buildInputs = [ libmikmod ncurses ];

  meta = {
    description = "Tracker music player for the terminal";
    homepage = "http://mikmod.shlomifish.org/";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
