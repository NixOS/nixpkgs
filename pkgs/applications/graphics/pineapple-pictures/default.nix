{ lib
, stdenv
, fetchFromGitHub
, qtsvg
, qttools
, exiv2
, wrapQtAppsHook
, cmake
}:

stdenv.mkDerivation rec {
  pname = "pineapple-pictures";
  version = "0.6.9";

  src = fetchFromGitHub {
    owner = "BLumia";
    repo = "pineapple-pictures";
    rev = version;
    sha256 = "sha256-QFKo4zMqhKzFseXMnZEBd2DPo0QObpelvYmI2tMyfRE=";
  };

  nativeBuildInputs = [
    cmake
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    qtsvg
    exiv2
  ];

  cmakeFlags = [
    "-DPREFER_QT_5=OFF"
  ];

  meta = with lib; {
    description = "Homebrew lightweight image viewer";
    homepage = "https://github.com/BLumia/pineapple-pictures";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rewine ];
  };
}
