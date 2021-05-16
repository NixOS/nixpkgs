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
}:

mkDerivation rec {
  pname = "kdeltachat";
  version = "unstable-2021-05-16";

  src = fetchFromSourcehut {
    owner = "~link2xt";
    repo = "kdeltachat";
    rev = "670960e18a7e9a1d994f26af27a12c73a7413c9a";
    sha256 = "1k065pvz1p2wm1rvw4nlcmknc4z10ya4qfch5kz77bbhkf9vfw2l";
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
  ];

  meta = with lib; {
    description = "Delta Chat client using Kirigami framework";
    homepage = "https://git.sr.ht/~link2xt/kdeltachat";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
