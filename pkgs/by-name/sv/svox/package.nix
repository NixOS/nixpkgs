{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  popt,
}:

stdenv.mkDerivation {
  pname = "svox";
<<<<<<< HEAD
  version = "0-unstable-2021-05-06";
=======
  version = "2018-02-14";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # basically took the source code from android and borrowed autotool patches from debian
  src = fetchFromGitHub {
    owner = "naggety";
    repo = "picotts";
<<<<<<< HEAD
    rev = "21089d223e177ba3cb7e385db8613a093dff74b5";
    hash = "sha256-NmmYa3mVUSMsLC1blFAET3zLY66anGY2ff6ZQ424h1s=";
  };

  patches = [
    # upstream PR: https://github.com/ihuguet/picotts/pull/14
    ./fix-compilation-darwin.patch
  ];

=======
    rev = "e3ba46009ee868911fa0b53db672a55f9cc13b1c";
    sha256 = "0k3m7vh1ak9gmxd83x29cvhzfkybgz5hnlhd9xj19l1bjyx84s8v";
  };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  postPatch = ''
    cd pico
  '';

  buildInputs = [ popt ];

  nativeBuildInputs = [ autoreconfHook ];

<<<<<<< HEAD
  meta = {
    description = "Text-to-speech engine";
    homepage = "https://android.googlesource.com/platform/external/svox";
    platforms = lib.platforms.unix;
    license = lib.licenses.asl20;
=======
  meta = with lib; {
    description = "Text-to-speech engine";
    homepage = "https://android.googlesource.com/platform/external/svox";
    platforms = platforms.linux;
    license = licenses.asl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
    mainProgram = "pico2wave";
  };
}
