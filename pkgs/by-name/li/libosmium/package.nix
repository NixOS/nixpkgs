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
  version = "2.21.0";

  src = fetchFromGitHub {
    owner = "osmcode";
    repo = "libosmium";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IGZQBziXKYVG+uKLjHr6LsIF5H8klq6LGF5j1KrfHZU=";
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

  cmakeFlags = [ (lib.cmakeBool "INSTALL_GDALCPP" true) ];

  doCheck = true;

  meta = {
    description = "Fast and flexible C++ library for working with OpenStreetMap data";
    homepage = "https://osmcode.org/libosmium/";
    license = lib.licenses.boost;
    changelog = [
      "https://github.com/osmcode/libosmium/releases/tag/v${finalAttrs.version}"
      "https://github.com/osmcode/libosmium/blob/v${finalAttrs.version}/CHANGELOG.md"
    ];
    maintainers = lib.teams.geospatial.members ++ (with lib.maintainers; [ das-g ]);
  };
})
