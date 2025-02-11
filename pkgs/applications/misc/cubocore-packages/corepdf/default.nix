{
  mkDerivation,
  lib,
  fetchFromGitLab,
  qtbase,
  poppler,
  qtwebengine,
  cmake,
  ninja,
  libcprime,
  libcsys,
}:

mkDerivation rec {
  pname = "corepdf";
  version = "4.5.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-t3r/bF/uKoprdDoRjrmYTND0Jws+jX6tAGnBeqofBF8=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtbase
    poppler
    qtwebengine
    libcprime
    libcsys
  ];

  meta = with lib; {
    description = "PDF viewer from the C Suite";
    mainProgram = "corepdf";
    homepage = "https://gitlab.com/cubocore/coreapps/corepdf";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
