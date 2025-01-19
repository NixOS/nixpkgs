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
  pname = "corepad";
  version = "4.5.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-qiw6P+I9iAcFcBWiMKAzyxM6waXx/2TPVQHLcLjAnoY=";
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

  meta = {
    description = "Document editor from the C Suite";
    mainProgram = "corepad";
    homepage = "https://gitlab.com/cubocore/coreapps/corepad";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dan4ik605743 ];
    platforms = lib.platforms.linux;
  };
}
