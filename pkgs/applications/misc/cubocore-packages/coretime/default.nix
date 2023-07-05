{ mkDerivation, lib, fetchFromGitLab, qtbase, qtmultimedia, cmake, ninja, libcprime, libcsys }:

mkDerivation rec {
  pname = "coretime";
  version = "4.4.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XTX4oeUFwfZE0ey1NjXpAzw0x+4d8IGwU/sEojRwBBY=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtbase
    qtmultimedia
    libcprime
    libcsys
  ];

  meta = with lib; {
    description = "A time related task manager from the C Suite";
    homepage = "https://gitlab.com/cubocore/coreapps/coretime";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
