{ stdenv
, fetchFromGitHub
, cmake
, nixosTests
, alsaLib
, SDL2
, libiconv
}:

stdenv.mkDerivation rec {
  pname = "ft2-clone";
  version = "1.40";

  src = fetchFromGitHub {
    owner = "8bitbubsy";
    repo = "ft2-clone";
    rev = "v${version}";
    sha256 = "0qc3hai6fhn4amk5ixmxx3yswsi25qpax0r9nvvnyhbcb6crqcs1";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ SDL2 ]
    ++ stdenv.lib.optional stdenv.isLinux alsaLib
    ++ stdenv.lib.optional stdenv.isDarwin libiconv;

  passthru.tests = {
    ft2-clone-starts = nixosTests.ft2-clone;
  };

  meta = with stdenv.lib; {
    description = "A highly accurate clone of the classic Fasttracker II software for MS-DOS";
    homepage = "https://16-bits.org/ft2.php";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
}

