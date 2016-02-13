{ stdenv, fetchgit, SDL2, SDL2_ttf, freeimage }:

stdenv.mkDerivation rec {
  name = "imv-${version}";
  version = "2.0.0";

  src = fetchgit {
    url = "https://github.com/eXeC64/imv.git";
    rev = "bc90a0adcc5b22d2bf0158333eb6dfb34c402d48";
    sha256 = "1bzx57d9mcxw9s72pdbdbwq9pns946jl6p2g881z43w68gimlpw7";
  };

  buildInputs = [ SDL2 SDL2_ttf freeimage ];

  configurePhase = "substituteInPlace Makefile --replace /usr $out";

  meta = with stdenv.lib; {
    description = "A command line image viewer for tiling window managers";
    homepage    = https://github.com/eXeC64/imv; 
    license     = licenses.gpl2;
    maintainers = with maintainers; [ rnhmjoj ];
    platforms   = platforms.unix;
  };
}

