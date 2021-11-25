{ mkDerivation, lib, fetchFromGitLab, qtbase, poppler, cmake, ninja, libcprime, libcsys }:

mkDerivation rec {
  pname = "corepdf";
  version = "4.2.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HeOklgCwJ5h3DeelJOZqasG+eC9DGG3R0Cqg2yPKYhM=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtbase
    poppler
    libcprime
    libcsys
  ];

  meta = with lib; {
    description = "A PDF viewer from the C Suite";
    homepage = "https://gitlab.com/cubocore/coreapps/corepdf";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
