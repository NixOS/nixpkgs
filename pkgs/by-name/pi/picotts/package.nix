{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  popt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "picotts";
  version = "0-unstable-2021-05-06";

  src = fetchFromGitHub {
    repo = "picotts";
    owner = "naggety";
    rev = "21089d223e177ba3cb7e385db8613a093dff74b5";
    sha256 = "sha256-NmmYa3mVUSMsLC1blFAET3zLY66anGY2ff6ZQ424h1s=";
  };

  patches = [
    # upstream PR: https://github.com/ihuguet/picotts/pull/14
    ./fix-compilation-darwin.patch
  ];

  postPatch = ''
    cd pico
  '';

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    popt
  ];

  meta = {
    description = "Text to speech voice sinthesizer from SVox";
    homepage = "https://github.com/naggety/picotts";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.canndrew ];
    platforms = lib.platforms.unix;
    mainProgram = "pico2wave";
  };
})
