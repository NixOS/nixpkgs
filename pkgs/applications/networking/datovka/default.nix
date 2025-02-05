{ lib
, mkDerivation
, fetchurl
, libxml2
, libdatovka
, qmake
, qtbase
, qtwebsockets
, qtsvg
, pkg-config
}:

mkDerivation rec {
  pname = "datovka";
  version = "4.25.0";

  src = fetchurl {
    url = "https://gitlab.nic.cz/datovka/datovka/-/archive/v${version}/datovka-v${version}.tar.gz";
    sha256 = "sha256-Snm9dDtHZQsx4T82tML77auBTb1lvITUOfL+kmhY4es=";
  };

  buildInputs = [ libdatovka qmake qtbase qtsvg libxml2 qtwebsockets ];

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "Client application for operating Czech government-provided Databox infomation system";
    homepage = "https://www.datovka.cz/";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.mmahut ];
    platforms = platforms.linux;
    mainProgram = "datovka";
  };
}
