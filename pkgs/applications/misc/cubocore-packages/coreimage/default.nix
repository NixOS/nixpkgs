{ mkDerivation, lib, fetchFromGitLab, qtbase, cmake, ninja, libcprime, libcsys }:

mkDerivation rec {
  pname = "coreimage";
  version = "4.3.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-uG9/8sQK0G3f7O59OHEHqNHP8cUC73hmjsfpOnj0kFM=";
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
    description = "An image viewer from the C Suite";
    homepage = "https://gitlab.com/cubocore/coreapps/coreimage";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
