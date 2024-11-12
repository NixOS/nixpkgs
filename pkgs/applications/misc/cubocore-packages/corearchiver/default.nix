{ mkDerivation, lib, fetchFromGitLab, qtbase, libarchive, libarchive-qt, cmake, ninja, libcprime, libcsys }:

mkDerivation rec {
  pname = "corearchiver";
  version = "4.5.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-TKBr/CFY4ixQnJuaN+wJB88s6g4lvQz4rwq9YsccRYk=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtbase
    libarchive-qt
    libarchive
    libcprime
    libcsys
  ];

  meta = with lib; {
    description = "Archiver from the C Suite to create and extract archives";
    mainProgram = "corearchiver";
    homepage = "https://gitlab.com/cubocore/coreapps/corearchiver";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
