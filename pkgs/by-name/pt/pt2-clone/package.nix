{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nixosTests,
  alsa-lib,
  SDL2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pt2-clone";
<<<<<<< HEAD
  version = "1.80.1";
=======
  version = "1.78";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "8bitbubsy";
    repo = "pt2-clone";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    sha256 = "sha256-GJT9TxlM6O1PT1CKAgRtnivbC3RtzcglROx26S4G0Bc=";
=======
    sha256 = "sha256-qbzs+EaypbulB1jkKQHMbhXwJIQwoyqVCdSvx5vYk2A=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ SDL2 ] ++ lib.optional stdenv.hostPlatform.isLinux alsa-lib;

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

<<<<<<< HEAD
  meta = {
    description = "Highly accurate clone of the classic ProTracker 2.3D software for Amiga";
    homepage = "https://16-bits.org/pt2.php";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fgaz ];
    # From HOW-TO-COMPILE.txt:
    # > This code is NOT big-endian compatible
    platforms = lib.platforms.littleEndian;
=======
  meta = with lib; {
    description = "Highly accurate clone of the classic ProTracker 2.3D software for Amiga";
    homepage = "https://16-bits.org/pt2.php";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fgaz ];
    # From HOW-TO-COMPILE.txt:
    # > This code is NOT big-endian compatible
    platforms = platforms.littleEndian;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "pt2-clone";
  };
})
