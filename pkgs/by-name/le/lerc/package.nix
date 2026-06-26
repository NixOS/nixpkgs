{
  lib,
  stdenv,
  buildPackages,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lerc";
  version = "4.1.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "esri";
    repo = "lerc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+X30DQuq2oT/sTe8usUaNK1V+UTNvXJW7IAJVIr8m78=";
  };

  # Required to get the freebsd-ports patch to apply.
  # There seem to be inconsistent line endings in this project - just converting the patch doesn't work
  prePatch = lib.optionalString stdenv.hostPlatform.isFreeBSD ''
    ${buildPackages.dos2unix}/bin/dos2unix src/LercLib/fpl_EsriHuffman.cpp src/LercLib/fpl_Lerc2Ext.cpp
  '';

  patches = lib.optionals stdenv.hostPlatform.isFreeBSD [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/freebsd/freebsd-ports/ee9e39ceb1af729ac33854b5f3de652cb5ce0eca/graphics/lerc/files/patch-_assert";
      hash = "sha256-agvGqgIsKS8v43UZdTVxDRDGbZdj2+AzKoQONvQumB4=";
      extraPrefix = "";
    })
  ];

  nativeBuildInputs = [
    cmake
  ];

  passthru.tests.pkg-config = testers.hasPkgConfigModules {
    package = finalAttrs.finalPackage;
  };

  meta = {
    changelog = "https://github.com/Esri/lerc/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "C++ library for Limited Error Raster Compression";
    homepage = "https://github.com/esri/lerc";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
    pkgConfigModules = [ "Lerc" ];
  };
})
