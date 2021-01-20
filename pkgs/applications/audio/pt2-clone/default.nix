{ lib, stdenv
, fetchFromGitHub
, cmake
, nixosTests
, alsaLib
, SDL2
}:

stdenv.mkDerivation rec {
  pname = "pt2-clone";
  version = "1.28";

  src = fetchFromGitHub {
    owner = "8bitbubsy";
    repo = "pt2-clone";
    rev = "v${version}";
    sha256 = "1c2x43f46l7556kl9y9qign0g6ywdkh7ywkzv6c9y63n68ph20x2";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ SDL2 ] ++ lib.optional stdenv.isLinux alsaLib;

  passthru.tests = {
    pt2-clone-opens = nixosTests.pt2-clone;
  };

  meta = with lib; {
    description = "A highly accurate clone of the classic ProTracker 2.3D software for Amiga";
    homepage = "https://16-bits.org/pt2.php";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fgaz ];
    # From HOW-TO-COMPILE.txt:
    # > This code is NOT big-endian compatible
    platforms = platforms.littleEndian;
  };
}

