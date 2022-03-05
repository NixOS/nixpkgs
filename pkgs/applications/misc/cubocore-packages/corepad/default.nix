{ mkDerivation, lib, fetchFromGitLab, qtbase, cmake, ninja, libcprime, libcsys }:

mkDerivation rec {
  pname = "corepad";
  version = "4.3.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-19qR08QhWeeXnJAQHe1SJjT0xnQLlbkXlzmd9uiMp14=";
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
