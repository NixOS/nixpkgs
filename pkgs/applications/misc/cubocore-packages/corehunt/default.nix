{ mkDerivation, lib, fetchFromGitLab, qtbase, cmake, ninja, libcprime, libcsys }:

mkDerivation rec {
  pname = "corehunt";
  version = "4.5.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Xir1RQG7AlO166lZq1TJssiWoSixY6EfLEjxek+9ifo=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtbase
    libcprime
    libcsys
  ];

  meta = with lib; {
    description = "File finder utility from the C Suite";
    mainProgram = "corehunt";
    homepage = "https://gitlab.com/cubocore/coreapps/corehunt";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
