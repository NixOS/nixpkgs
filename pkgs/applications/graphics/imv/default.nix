{ stdenv, fetchgit, SDL2, SDL2_ttf, freeimage, fontconfig }:

stdenv.mkDerivation rec {
  name = "imv-${version}";
  version = "2.1.2";

  src = fetchgit {
    url = "https://github.com/eXeC64/imv.git";
    rev = "3e6402456b00e29f659baf26ced10f3d7205cf63";
    sha256 = "0fhc944g7b61jrkd4wn1piq6dkpabsbxpm80pifx9dqmj16sf0pf";
  };

  buildInputs = [ SDL2 SDL2_ttf freeimage fontconfig ];

  configurePhase = "substituteInPlace Makefile --replace /usr $out";

  meta = with stdenv.lib; {
    description = "A command line image viewer for tiling window managers";
    homepage    = https://github.com/eXeC64/imv; 
    license     = licenses.gpl2;
    maintainers = with maintainers; [ rnhmjoj ];
    platforms   = platforms.unix;
  };
}

