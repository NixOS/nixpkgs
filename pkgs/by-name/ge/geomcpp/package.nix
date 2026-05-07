{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  glm,
  gtest,
  tinycmmc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "geomcpp";
  version = "0.0.0-unstable-2025-06-11";

  src = fetchFromGitHub {
    owner = "Grumbel";
    repo = "geomcpp";
    rev = "282e3710fbe6dacee630391e4af8ffe03181f8a9";
    sha256 = "sha256-M4a6P6J/PBDklpOiR81Nah0STlXFI48+mQkNqMBicKQ=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    gtest
    tinycmmc
  ];
  propagatedBuildInputs = [ glm ];

  cmakeFlags = [
    "-DWARNINGS=ON"
    "-DWERROR=ON"
    "-DBUILD_TESTS=ON"
  ];

  doCheck = true;

  postPatch = ''
    echo $version > VERSION
  '';

  meta = {
    description = "Collection of point, size and rect classes";
    maintainers = [ lib.maintainers.SchweGELBin ];
    platforms = lib.platforms.linux;
    license = lib.licenses.free;
  };
})
