{ stdenv
, fetchFromGitHub
, cmake
, alsaLib
, SDL2
}:

stdenv.mkDerivation rec {
  pname = "ft2-clone";
  version = "1.28";

  src = fetchFromGitHub {
    owner = "8bitbubsy";
    repo = "ft2-clone";
    rev = "v${version}";
    sha256 = "1hbcl89cpx9bsafxrjyfx6vrbs4h3lnzmqm12smcvdg8ksfgzj0d";
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

