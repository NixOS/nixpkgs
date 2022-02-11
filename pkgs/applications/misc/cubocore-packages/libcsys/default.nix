{ mkDerivation, lib, fetchFromGitLab, udisks2, qtbase, cmake, ninja }:

mkDerivation rec {
  pname = "libcsys";
  version = "4.2.0";

  src = fetchFromGitLab {
    owner = "cubocore";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9LH95uJJIn4FHfnikGi5UCI6nUNW+1cSZnJ/KpZDI5Y=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtbase
    udisks2
  ];

  meta = with lib; {
    description = "Library for managing drive and getting system resource information in real time";
    homepage = "https://gitlab.com/cubocore/libcsys";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
