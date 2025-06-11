{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  popt,
}:

stdenv.mkDerivation {
  pname = "svox";
  version = "2018-02-14";

  # basically took the source code from android and borrowed autotool patches from debian
  src = fetchFromGitHub {
    owner = "naggety";
    repo = "picotts";
    rev = "e3ba46009ee868911fa0b53db672a55f9cc13b1c";
    sha256 = "0k3m7vh1ak9gmxd83x29cvhzfkybgz5hnlhd9xj19l1bjyx84s8v";
  };

  postPatch = ''
    cd pico
  '';

  buildInputs = [ popt ];

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "Text-to-speech engine";
    homepage = "https://android.googlesource.com/platform/external/svox";
    platforms = platforms.linux;
    license = licenses.asl20;
    maintainers = with maintainers; [ abbradar ];
    mainProgram = "pico2wave";
  };
}
