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
  version = "4.5.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-zMSE1gQ2HJQCqil3MB4slRe0Cojv2XRLd8wLTokF8H0=";
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
