{ stdenv
, fetchFromGitHub
, cmake
, nixosTests
, alsaLib
, SDL2
}:

stdenv.mkDerivation rec {
  pname = "pt2-clone";
  version = "1.22";

  src = fetchFromGitHub {
    owner = "8bitbubsy";
    repo = "pt2-clone";
    rev = "v${version}";
    sha256 = "1w6lbq4366bawy975glvjizk57zhvl562xhxwzn7p5hpm2bvw09b";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ SDL2 ] ++ stdenv.lib.optional stdenv.isLinux alsaLib;

  passthru.tests = {
    pt2-clone-opens = nixosTests.pt2-clone;
  };

  meta = with stdenv.lib; {
    description = "A highly accurate clone of the classic ProTracker 2.3D software for Amiga";
    homepage = "https://16-bits.org/pt2.php";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
}

