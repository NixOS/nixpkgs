{ mkDerivation
, lib
, fetchurl
, cmake
, qtbase
, qtwebkit
, qttools
}:

mkDerivation rec {
  name = "trojita-${version}";
  version = "0.7";

  src = fetchurl {
    url = "mirror://sourceforge/trojita/trojita/${name}.tar.xz";
    sha256 = "1n9n07md23ny6asyw0xpih37vlwzp7vawbkprl7a1bqwfa0si3g0";
  };

  buildInputs = [
    qtbase
    qtwebkit
  ];

  nativeBuildInputs = [
    cmake
    qttools
  ];


  meta = with lib; {
    description = "A Qt IMAP e-mail client";
    homepage = http://trojita.flaska.net/;
    license = with licenses; [ gpl2 gpl3 ];
    platforms = platforms.linux;
  };

}
