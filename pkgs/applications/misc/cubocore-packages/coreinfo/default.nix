{ mkDerivation, lib, fetchFromGitLab, qtbase, libzen, libmediainfo, zlib, cmake, ninja, libcprime, libcsys }:

mkDerivation rec {
  pname = "coreinfo";
  version = "4.4.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-EWz2FQQzWVeP2qw1pz2Lg3COUo2y7/9a105R1Bj0Aqw=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtbase
    libzen
    libmediainfo
    zlib
    libcprime
    libcsys
  ];

  meta = with lib; {
    description = "A file information tool from the C Suite";
    homepage = "https://gitlab.com/cubocore/coreapps/coreinfo";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
