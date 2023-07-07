{ mkDerivation, lib, fetchFromGitLab, qtbase, cmake, ninja, libcprime, libcsys }:

mkDerivation rec {
  pname = "corepad";
  version = "4.4.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-MZdEdGfCaQp5DuDDYRNXi37O+O/aRS8XgAN0Jma/J3k=";
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
    description = "A document editor from the C Suite";
    homepage = "https://gitlab.com/cubocore/coreapps/corepad";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
