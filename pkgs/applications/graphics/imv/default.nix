{ stdenv, fetchFromGitHub,
  SDL2, freeimage
}:

stdenv.mkDerivation rec {
  name = "imv-${version}";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "eXeC64";
    repo  = "imv";
    rev = "4d1a6d581b70b25d9533c5c788aab6900ebf82bb";
    sha256 = "1c5r4pqqypir8ymicxyn2k7mhq8nl88b3x6giaafd77ssjn0vz9r";
  };

  buildInputs = [ SDL2 freeimage ];

  configurePhase = "substituteInPlace Makefile --replace /usr $out";

  meta = with stdenv.lib; {
    description = "A command line image viewer for tiling window managers";
    homepage    = https://github.com/eXeC64/imv; 
    license     = licenses.gpl2;
    maintainers = with maintainers; [ rnhmjoj ];
    platforms   = platforms.unix;
  };
}

