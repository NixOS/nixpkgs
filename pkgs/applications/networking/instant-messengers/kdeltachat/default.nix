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
  version = "unstable-2021-06-14";

  src = fetchFromSourcehut {
    owner = "~link2xt";
    repo = "kdeltachat";
    rev = "25da4228768e260ea9f67d5aa10558e7cf9cf7ee";
    sha256 = "17igh34cbd0w5mzra4k779nxc5s8hk6sj25h308w079y0b21lf7w";
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
