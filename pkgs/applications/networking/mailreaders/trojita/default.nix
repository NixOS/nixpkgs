{ mkDerivation
, lib
, fetchgit
, cmake
, qtbase
, qtwebkit
}:

mkDerivation rec {
  name = "trojita-${version}";
  version = "0.7";

  src = fetchgit {
    url = "https://anongit.kde.org/trojita.git";
    rev = "065d527c63e8e4a3ca0df73994f848b52e14ed58";
    sha256 = "1zlwhir33hha2p3l08wnb4njnfdg69j88ycf1fa4q3x86qm3r7hw";
  };

  buildInputs = [
    qtbase
    qtwebkit
  ];

  nativeBuildInputs = [
    cmake
  ];


  meta = with lib; {
    description = "A Qt IMAP e-mail client";
    homepage = http://trojita.flaska.net/;
    license = with licenses; [ gpl2 gpl3 ];
    platforms = platforms.linux;
  };

}
