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
  version = "1.41_fix";

  src = fetchFromGitHub {
    owner = "8bitbubsy";
    repo = "ft2-clone";
    rev = "v${version}";
    sha256 = "0c7jli79ckachl5n2rbhc4yzml8nc36pl9yzxcwgaz544q8pzmaa";
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
    # From HOW-TO-COMPILE.txt:
    # > This code is NOT big-endian compatible
    platforms = platforms.littleEndian;
  };
}

