{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, boost
, qtbase
, qttools
, libsForQt512
, wrapQtAppsHook}:

stdenv.mkDerivation rec {
  pname = "dspdfviewer";
  version = "1.15.1";

  src = fetchFromGitHub {
    owner = "dannyedel";
    repo = pname;
    rev = "v${version}";
    sha256 = "0n1biiyi77inkyfmzfvl84jp69hqlnsphbr9j97gsh0np6pxnf1l";
  };

  buildInputs = [
    cmake
    pkg-config
  ];

  nativeBuildInputs = [
    boost
    qtbase
    qttools
    libsForQt512.poppler
    wrapQtAppsHook
  ];

  cmakeFlags = [
    "-DBuildTests=Off"
  ];

  meta = with lib; {
    description = "Multi screen pdf presentation viewer designed for latex-beamer";
    homepage = "https://dspdfviewer.danny-edel.de";
    license = with licenses; [ gpl2Plus ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ martiert ];
  };
}
