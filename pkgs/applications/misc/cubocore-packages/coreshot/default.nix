{ mkDerivation, lib, fetchFromGitLab, qtbase, qtx11extras, cmake, ninja, libcprime, libcsys }:

mkDerivation rec {
  pname = "coreshot";
  version = "4.5.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-XPECvwZkJIoN/r5oFWJpgl/WASpybgLjCK/F0XVMHyU=";
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
