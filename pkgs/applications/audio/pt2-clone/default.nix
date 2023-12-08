{ lib, stdenv
, fetchFromGitHub
, cmake
, nixosTests
, alsa-lib
, SDL2
}:

stdenv.mkDerivation rec {
  pname = "pt2-clone";
  version = "1.65.1";

  src = fetchFromGitHub {
    owner = "8bitbubsy";
    repo = "pt2-clone";
    rev = "v${version}";
    sha256 = "sha256-0bZGiulLeAZ8bR0lj0Bm7te3T3YhxSOBFgMgWADRkIY=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ SDL2 ] ++ lib.optional stdenv.isLinux alsa-lib;

  postInstall = ''
    install -Dm444 "$src/release/other/Freedesktop.org Resources/ProTracker 2 clone.desktop" \
      -t $out/share/applications
    install -Dm444 "$src/release/other/Freedesktop.org Resources/ProTracker 2 clone.png" \
      -t $out/share/icons/hicolor/512x512/apps
  '';

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

