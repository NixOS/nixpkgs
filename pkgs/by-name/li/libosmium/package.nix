{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  protozero,
  expat,
  zlib,
  bzip2,
  boost,
  lz4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libosmium";
  version = "2.22.0";

  src = fetchFromGitHub {
    owner = "osmcode";
    repo = "libosmium";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b4jdPh6lJ/ALPVblDt16Nabx9ZL8MW8/roI+NqTZshU=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    protozero
    zlib
    bzip2
    expat
    boost
    lz4
  ];

  cmakeFlags = [
    # Fix the build with CMake 4.
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    (lib.cmakeBool "INSTALL_GDALCPP" true)
  ];

  doCheck = true;

  meta = {
    description = "Fast and flexible C++ library for working with OpenStreetMap data";
    homepage = "https://osmcode.org/libosmium/";
    license = lib.licenses.boost;
    changelog = [
      "https://github.com/osmcode/libosmium/releases/tag/v${finalAttrs.version}"
      "https://github.com/osmcode/libosmium/blob/v${finalAttrs.version}/CHANGELOG.md"
    ];
    maintainers = with lib.maintainers; [ das-g ];
    teams = [ lib.teams.geospatial ];
  };
})
