{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  popt,
}:

stdenv.mkDerivation {
  pname = "svox";
  version = "0-unstable-2021-05-06";

  # basically took the source code from android and borrowed autotool patches from debian
  src = fetchFromGitHub {
    owner = "naggety";
    repo = "picotts";
    rev = "21089d223e177ba3cb7e385db8613a093dff74b5";
    hash = "sha256-NmmYa3mVUSMsLC1blFAET3zLY66anGY2ff6ZQ424h1s=";
  };

  patches = [
    # upstream PR: https://github.com/ihuguet/picotts/pull/14
    ./fix-compilation-darwin.patch
  ];

  postPatch = ''
    cd pico
  '';

  buildInputs = [ popt ];

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "Text-to-speech engine";
    homepage = "https://android.googlesource.com/platform/external/svox";
    platforms = lib.platforms.unix;
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "pico2wave";
  };
}
