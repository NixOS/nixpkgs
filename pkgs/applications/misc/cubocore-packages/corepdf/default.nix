{ mkDerivation, lib, fetchFromGitLab, qtbase, poppler, qtwebengine, cmake, ninja, libcprime, libcsys }:

mkDerivation rec {
  pname = "corepdf";
  version = "4.4.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Dm3RDVHw1JXSC3HdS0k/IVTO/o5vaWiCr5vPDjr2uFk=";
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
    description = "A PDF viewer from the C Suite";
    homepage = "https://gitlab.com/cubocore/coreapps/corepdf";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
