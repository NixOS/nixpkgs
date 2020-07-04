{ mkDerivation, lib, fetchFromGitHub, qmake, qtbase }:

mkDerivation rec {
  pname = "qview";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "jurplel";
    repo = "qView";
    rev = version;
    sha256 = "15a91bs3wcqhgf76wzigbn10hayg628j84pq4j2vaxar94ak0vk7";
  };

  nativeBuildInputs = [ qmake ];

  buildInputs = [
    qtbase
  ];

  patchPhase = ''
    sed "s|/usr/|$out/|g" -i qView.pro
  '';

  meta = with lib; {
    description = "Practical and minimal image viewer";
    homepage = "https://interversehq.com/qview/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ acowley ];
    platforms = platforms.all;
  };
}
