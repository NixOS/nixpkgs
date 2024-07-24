{ lib, stdenv
, fetchFromGitHub
, cmake
, nixosTests
, alsa-lib
, SDL2
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pt2-clone";
  version = "1.69.2";

  src = fetchFromGitHub {
    owner = "8bitbubsy";
    repo = "pt2-clone";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Vy8b9rbYM/bK/mCUW4V4rPeAmoBN/wn7iVBANSboL2Q=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ SDL2 ] ++ lib.optional stdenv.isLinux alsa-lib;

  postInstall = ''
    install -Dm444 "$src/release/other/Freedesktop.org Resources/ProTracker 2 clone.desktop" \
      $out/share/applications/pt2-clone.desktop
    install -Dm444 "$src/release/other/Freedesktop.org Resources/ProTracker 2 clone.png" \
      $out/share/icons/hicolor/512x512/apps/pt2-clone.png
    # gtk-update-icon-cache does not like whitespace. Note that removing this
    # will not make the build fail, but it will make the NixOS test fail.
    substituteInPlace $out/share/applications/pt2-clone.desktop \
      --replace-fail "Icon=ProTracker 2 clone" Icon=pt2-clone
  '';

  passthru.tests = {
    pt2-clone-opens = nixosTests.pt2-clone;
  };

  meta = with lib; {
    description = "Highly accurate clone of the classic ProTracker 2.3D software for Amiga";
    homepage = "https://16-bits.org/pt2.php";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fgaz ];
    # From HOW-TO-COMPILE.txt:
    # > This code is NOT big-endian compatible
    platforms = platforms.littleEndian;
    mainProgram = "pt2-clone";
  };
})
