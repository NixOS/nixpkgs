{ qt5
, lib
, fetchzip
, callPackage
, cmake
, ninja
}:

let
  qtermwidget = callPackage ./qtermwidget/default.nix {};
  libcprime = callPackage ./libcprime/default.nix {};
in

qt5.mkDerivation rec {
  pname = "coreterminal";
  version = "4.2.0";

  src = fetchzip {
    url = "https://gitlab.com/cubocore/coreapps/${pname}/-/archive/v${version}/${pname}-v${version}.tar.gz";
    sha256 = "sha256-YXs6VTem3AaK4n1DYwKP/jqNuf09Srn2THHyJJnArlc=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qt5.full
    qtermwidget
    libcprime
  ];

  meta = with lib; {
    description = "A terminal emulator from the C Suite";
    homepage = "https://gitlab.com/cubocore/coreapps/coreterminal";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
