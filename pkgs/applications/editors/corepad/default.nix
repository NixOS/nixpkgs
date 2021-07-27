{ mkDerivation, lib, fetchFromGitLab, qtbase, libcprime, cmake, ninja }:

mkDerivation rec {
  pname = "corepad";
  version = "4.2.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2bGHVv0+0NlkIqnvWm014Kr20uARWnOS5xSuNmCt/bQ=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtbase
    libcprime
  ];

  meta = with lib; {
    description = "A document editor from the C Suite";
    homepage = "https://gitlab.com/cubocore/coreapps/corepad";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
