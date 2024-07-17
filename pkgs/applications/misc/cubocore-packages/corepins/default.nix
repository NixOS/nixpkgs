{
  mkDerivation,
  lib,
  fetchFromGitLab,
  qtbase,
  cmake,
  ninja,
  libcprime,
  libcsys,
}:

mkDerivation rec {
  pname = "corepins";
  version = "4.5.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-vA2Phs+sEs+Gd73xzj6vb91Krm8q3+koWDM7rCUayTQ=";
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
    description = "A bookmarking app from the C Suite";
    mainProgram = "corepins";
    homepage = "https://gitlab.com/cubocore/coreapps/corepins";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
