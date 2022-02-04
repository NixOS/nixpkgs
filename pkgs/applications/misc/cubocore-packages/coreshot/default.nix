{ mkDerivation, lib, fetchFromGitLab, qtbase, qtx11extras, cmake, ninja, libcprime, libcsys }:

mkDerivation rec {
  pname = "coreshot";
  version = "4.2.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HKgGeuM3CKGXwnFwSw6a0AB0klZKY5YS9C4q2UT6TN8=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtbase
    qtx11extras
    libcprime
    libcsys
  ];

  meta = with lib; {
    description = "A screen capture utility from the C Suite";
    homepage = "https://gitlab.com/cubocore/coreapps/coreshot";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
