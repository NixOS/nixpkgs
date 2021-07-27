{ mkDerivation, lib, fetchFromGitLab, qtbase, libcprime, libzen, libmediainfo, zlib, cmake, ninja }:

mkDerivation rec {
  pname = "coreinfo";
  version = "4.2.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-kLBOvvulHE1+4TyZVEVZwEA+Id7+w8fI3ll+QL2ukr0=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtbase
    libcprime
    libzen
    libmediainfo
    zlib
  ];

  meta = with lib; {
    description = "A file information tool from the C Suite";
    homepage = "https://gitlab.com/cubocore/coreapps/coreinfo";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
