{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "imath";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "imath";
    rev = "v${version}";
    hash = "sha256-O8IpP2MQ7egDbHIiL5TNBygmQCiS6Q/0VSe0LypsM/g=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "C++ and python library of 2D and 3D vector, matrix, and math operations for computer graphics";
    homepage = "https://github.com/AcademySoftwareFoundation/Imath";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ paperdigits ];
    platforms = lib.platforms.all;
  };
}
