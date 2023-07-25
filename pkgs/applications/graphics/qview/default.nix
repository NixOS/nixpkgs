{ lib
, mkDerivation
, fetchFromGitHub
, qmake
, qtbase
, qttools
, qtimageformats
, qtsvg
}:

mkDerivation rec {
  pname = "qview";
  version = "5.0";

  src = fetchFromGitHub {
    owner = "jurplel";
    repo = "qView";
    rev = version;
    hash = "sha256-VQ0H9iPrrxO9e/kMo7yZ/zN5I2qDWBCAFacS9uGuZLI=";
  };

  nativeBuildInputs = [ qmake ];

  buildInputs = [
    qtbase
    qttools
    qtimageformats
    qtsvg
  ];

  meta = with lib; {
    description = "Practical and minimal image viewer";
    homepage = "https://interversehq.com/qview/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ acowley ];
    platforms = platforms.all;
  };
}
