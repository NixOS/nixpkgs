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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "BLumia";
    repo = "pineapple-pictures";
    rev = version;
    hash = "sha256-fNme11zoQBoFz4qJxBWzA8qHPwwxirM9rxxT36tjiQs";
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
    mainProgram = "ppic";
    maintainers = with maintainers; [ rewine ];
  };
}
