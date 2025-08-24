{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "imath";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "imath";
    rev = "v${version}";
    sha256 = "sha256-tdJh8aRVakdu2zDeGA/0JCCNzdv6s6x55eUpgNJtuI0=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "C++ and python library of 2D and 3D vector, matrix, and math operations for computer graphics";
    homepage = "https://github.com/AcademySoftwareFoundation/Imath";
    license = licenses.bsd3;
    maintainers = with maintainers; [ paperdigits ];
    platforms = platforms.all;
  };
}
