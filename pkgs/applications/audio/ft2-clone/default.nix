{ stdenv
, fetchFromGitHub
, cmake
, alsaLib
, SDL2
}:

stdenv.mkDerivation rec {
  pname = "ft2-clone";
  version = "1.15";

  src = fetchFromGitHub {
    owner = "8bitbubsy";
    repo = "ft2-clone";
    rev = "v${version}";
    sha256 = "19xgdaij71gpvq216zjlp60zmfdl2a8kf8sc3bpk8a4d4xh4n151";
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

