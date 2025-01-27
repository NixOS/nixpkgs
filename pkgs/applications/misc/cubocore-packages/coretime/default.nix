{
  mkDerivation,
  lib,
  fetchFromGitLab,
  qtbase,
  qtmultimedia,
  cmake,
  ninja,
  libcprime,
  libcsys,
}:

mkDerivation rec {
  pname = "coretime";
  version = "4.5.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-0x3014UG861lXRwIBpYiiYVPmhln9Q20jJ4tIO50Tjs=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtbase
    qtmultimedia
    libcprime
    libcsys
  ];

  meta = with lib; {
    description = "Time related task manager from the C Suite";
    mainProgram = "coretime";
    homepage = "https://gitlab.com/cubocore/coreapps/coretime";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
