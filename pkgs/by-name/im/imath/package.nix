{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "imath";
  version = "3.2.2";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "imath";
    rev = "v${version}";
    hash = "sha256-uLGH2kMo5S6iT2gS1091qKkCAxQ/iuQ8xx9507k6SzY=";
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
