{ stdenv
, fetchFromGitHub
, cmake
, alsaLib
, SDL2
}:

stdenv.mkDerivation rec {
  pname = "ft2-clone";
  version = "1.31";

  src = fetchFromGitHub {
    owner = "8bitbubsy";
    repo = "ft2-clone";
    rev = "v${version}";
    sha256 = "02j876d4xmbdmqairrs5190dzdm3k4s5hi3g9wvx62cxnnw7igha";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ SDL2 ] ++ stdenv.lib.optional stdenv.isLinux alsaLib;

  meta = with stdenv.lib; {
    description = "A highly accurate clone of the classic Fasttracker II software for MS-DOS";
    homepage = "https://16-bits.org/ft2.php";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
}

