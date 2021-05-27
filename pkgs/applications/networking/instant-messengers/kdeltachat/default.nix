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
  version = "unstable-2021-05-22";

  src = fetchFromSourcehut {
    owner = "~link2xt";
    repo = "kdeltachat";
    rev = "9c22c6d6a03f620f14f289b464354159b8a76f6b";
    sha256 = "1qmal6dng8ynp5mrkrgykz78c8zp1gbv53s479qvj0h3axrp2s8p";
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
