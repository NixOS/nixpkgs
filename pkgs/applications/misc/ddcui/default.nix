{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkg-config
, qtbase
, qttools
, ddcutil
}:

mkDerivation rec {
  pname = "ddcui";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "rockowitz";
    repo = "ddcui";
    rev = "v${version}";
    sha256 = "sha256-a8UGdVLi+i8hvWE3M5d92vnm3VryxRR56jXeBtB2PSk=";
  };

  nativeBuildInputs = [
    # Using cmake instead of the also-supported qmake because ddcui's qmake
    # file is not currently written to support PREFIX installations.
    cmake
    pkg-config
  ];

  buildInputs = [
    qtbase
    qttools
    ddcutil
  ];

  meta = with lib; {
    description = "Graphical user interface for ddcutil - control monitor settings";
    homepage = "https://www.ddcutil.com/ddcui_main/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ nh2 ];
    platforms = with platforms; linux;
  };
}
