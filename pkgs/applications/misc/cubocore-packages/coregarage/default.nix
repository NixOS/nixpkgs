{
  mkDerivation,
  lib,
  fetchFromGitLab,
  qtbase,
  libarchive,
  libarchive-qt,
  cmake,
  ninja,
  libcprime,
  libcsys,
}:

mkDerivation rec {
  pname = "coregarage";
  version = "4.5.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-WCSc3ppYaktj9WnPb4n7SmSNWxT2HiXNmPKS3md3ST4=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtbase
    libarchive
    libarchive-qt
    libcprime
    libcsys
  ];

  meta = with lib; {
    description = "Settings manager for the C Suite";
    mainProgram = "coregarage";
    homepage = "https://gitlab.com/cubocore/coreapps/coregarage";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
