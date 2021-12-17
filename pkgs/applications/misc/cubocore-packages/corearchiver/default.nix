{ mkDerivation, lib, fetchFromGitLab, qtbase, libarchive, libarchive-qt, cmake, ninja, libcprime, libcsys }:

mkDerivation rec {
  pname = "corearchiver";
  version = "4.2.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FJGsQp1lbsrvlzKPiTv/FC9RH2+JRwwIvkLDTFW8t5s=";
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
    homepage = "https://gitlab.com/cubocore/coreapps/corearchiver";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
