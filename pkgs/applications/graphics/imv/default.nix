{ stdenv, fetchFromGitHub,
  SDL2, freeimage
}:

stdenv.mkDerivation rec {
  name = "imv-${version}";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "eXeC64";
    repo  = "imv";
    rev = "f2ce793d628e88825eff3364b293104cb0bdb582";
    sha256 = "1xqaqbfjgksbjmy1yy7q4sv5bak7w8va60xa426jzscy9cib2sgh";
  };

  buildInputs = [ SDL2 freeimage ];

  configurePhase = "substituteInPlace Makefile --replace /usr $out";

  meta = with stdenv.lib; {
    description = "A command line image viewer for tiling window managers";
    homepage    = https://github.com/eXeC64/imv; 
    license     = licenses.mit;
    maintainers = with maintainers; [ rnhmjoj ];
    platforms   = platforms.unix;
  };
}

