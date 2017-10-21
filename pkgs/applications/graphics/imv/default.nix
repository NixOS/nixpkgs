{ stdenv, fetchgit, SDL2, SDL2_ttf, freeimage, fontconfig }:

stdenv.mkDerivation rec {
  name = "imv-${version}";
  version = "2.1.3";

  src = fetchgit {
    url = "https://github.com/eXeC64/imv.git";
    rev = "e59d0e9e120f1dbde9ab068748a190e93978e5b7";
    sha256 = "0j48dk1bcbh5541522qkn487637wcx104zckrnxa5g3nirfqa7r7";
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

