{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:
let
  GTE_VERSION_MAJOR = "8";
  GTE_VERSION_MINOR = "2";
in

stdenv.mkDerivation (finalAttrs: {
  pname = "gtmathematics";
  version = "${GTE_VERSION_MAJOR}.${GTE_VERSION_MINOR}";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "davideberly";
    repo = "GeometricTools";
    tag = "GTE-version-${finalAttrs.version}";
    hash = "sha256-OmWcD3T9OoLd7WDyqCyCLl5TeNnLBm9xV7DJxnb4hJc=";
  };

  sourceRoot = "source/GTE/Mathematics";

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    (lib.cmakeFeature "GTE_VERSION_MAJOR" "${GTE_VERSION_MAJOR}")
    (lib.cmakeFeature "GTE_VERSION_MINOR" "${GTE_VERSION_MINOR}")
  ];

  meta = {
    description = "A collection of source code for computing in the fields of mathematics, geometry, graphics, image analysis and physics.";
    homepage = "https://www.geometrictools.com";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [
      wishstudio
    ];
    platforms = lib.platforms.all;
  };
})
