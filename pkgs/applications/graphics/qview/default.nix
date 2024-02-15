{ lib
, mkDerivation
, fetchFromGitHub
, qmake
, qtbase
, qttools
, qtimageformats
, qtsvg
, qtx11extras
, x11Support ? true
}:

mkDerivation rec {
  pname = "qview";
  version = "6.1";

  src = fetchFromGitHub {
    owner = "jurplel";
    repo = "qView";
    rev = version;
    hash = "sha256-h1K1Smfy875NoHtgUrOvZZp0IgcQdbyuQhXU9ndM4bA=";
  };

  qmakeFlags = lib.optionals (!x11Support) [ "CONFIG+=NO_X11" ];

  nativeBuildInputs = [ qmake ];

  buildInputs = [
    qtbase
    qttools
    qtimageformats
    qtsvg
  ] ++ lib.optionals x11Support [ qtx11extras ];

  meta = with lib; {
    description = "Practical and minimal image viewer";
    homepage = "https://interversehq.com/qview/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ acowley ];
    platforms = platforms.all;
  };
}
