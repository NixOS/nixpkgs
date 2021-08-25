{ mkDerivation, lib, fetchFromGitLab, libcprime, qtbase, cmake, ninja }:

mkDerivation rec {
  pname = "coreimage";
  version = "4.2.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dxRHzSG5ea1MhpTjgZbFztV9mElEaeOK4NsmieSgf5Q";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtbase
    libcprime
  ];

  meta = with lib; {
    description = "An image viewer from the C Suite";
    homepage = "https://gitlab.com/cubocore/coreapps/coreimage";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
