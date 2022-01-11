{ lib, stdenv, fetchurl, libmikmod, ncurses }:

stdenv.mkDerivation rec {
  pname = "mikmod";
  version = "3.2.8";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1k54p8pn3jinha0f2i23ad15pf1pamibzcxjrbzjbklpcz1ipc6v";
  };

  buildInputs = [ libmikmod ncurses ];

  meta = {
    description = "Tracker music player for the terminal";
    homepage = "http://mikmod.shlomifish.org/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ];
    platforms = with lib.platforms; linux;
  };
}
