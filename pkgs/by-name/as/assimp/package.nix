{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "assimp";
  version = "6.0.2";
  outputs = [
    "out"
    "lib"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "assimp";
    repo = "assimp";
    rev = "v${version}";
    hash = "sha256-ixtqK+3iiL17GEbEVHz5S6+gJDDQP7bVuSfRMJMGEOY=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    zlib
  ];

  cmakeFlags = [ "-DASSIMP_BUILD_ASSIMP_TOOLS=ON" ];

  meta = with lib; {
    description = "Library to import various 3D model formats";
    mainProgram = "assimp";
    homepage = "https://www.assimp.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ehmry ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
