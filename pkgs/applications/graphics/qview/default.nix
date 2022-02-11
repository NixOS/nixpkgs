{ lib
, mkDerivation
, fetchFromGitHub
, qmake
, qtbase
, qtimageformats
, qtsvg
}:

mkDerivation rec {
  pname = "qview";
  version = "4.0";

  src = fetchFromGitHub {
    owner = "jurplel";
    repo = "qView";
    rev = version;
    sha256 = "15n9cq7w3ckinnx38hvncxrbkv4qm4k51sal41q4y0pkvhmafhnr";
  };

  nativeBuildInputs = [ qmake ];

  buildInputs = [
    qtbase
    qtimageformats
    qtsvg
  ];

  patchPhase = ''
    sed "s|/usr/|$out/|g" -i qView.pro
  '';

  meta = with lib; {
    description = "Practical and minimal image viewer";
    homepage = "https://interversehq.com/qview/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ acowley ];
    platforms = platforms.all;
  };
}
