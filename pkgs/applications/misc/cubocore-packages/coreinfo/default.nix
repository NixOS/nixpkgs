{ mkDerivation, lib, fetchFromGitLab, qtbase, libzen, libmediainfo, zlib, cmake, ninja, libcprime, libcsys }:

mkDerivation rec {
  pname = "coreinfo";
  version = "4.3.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KoX2U07giVF2xZR1diM6teiNfKYRiqjowTJgnsMlaN0=";
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
