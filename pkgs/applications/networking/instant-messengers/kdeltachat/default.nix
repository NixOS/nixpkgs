{ lib
, mkDerivation
, fetchFromSourcehut
, cmake
, extra-cmake-modules
, pkg-config
, kirigami2
, libdeltachat
, qtimageformats
, qtmultimedia
, qtwebengine
}:

mkDerivation rec {
  pname = "kdeltachat";
  version = "unstable-2021-05-31";

  src = fetchFromSourcehut {
    owner = "~link2xt";
    repo = "kdeltachat";
    rev = "318ae67c17f3e64532bad23c2a61a93446db553d";
    sha256 = "1qy0hlp0r91sqn26ai9isxw4rl8kcmmb10a2p9yqynhm8py3dfn4";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
  ];

  buildInputs = [
    kirigami2
    libdeltachat
    qtimageformats
    qtmultimedia
    qtwebengine
  ];

  meta = with lib; {
    description = "Delta Chat client using Kirigami framework";
    homepage = "https://git.sr.ht/~link2xt/kdeltachat";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
