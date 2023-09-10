{ mkDerivation
, lib
, fetchFromGitLab
, qtbase
, qtserialport
, qtermwidget
, cmake
, ninja
, libcprime
, libcsys
}:

mkDerivation rec {
  pname = "coreterminal";
  version = "4.4.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-sFNKyqzNrPAGitmR8YEtIf6vtnvAP7+jXk4GFnDeGJs=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtbase
    qtserialport
    qtermwidget
    libcprime
    libcsys
  ];

  meta = with lib; {
    description = "A terminal emulator from the C Suite";
    homepage = "https://gitlab.com/cubocore/coreapps/coreterminal";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
