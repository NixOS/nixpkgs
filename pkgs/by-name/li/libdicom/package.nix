{
  lib,
  stdenv,
  buildPackages,
  fetchFromGitHub,
  uthash,
  meson,
  ninja,
  pkg-config,
  check,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdicom";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "ImagingDataCommons";
    repo = "libdicom";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Z1x6pA4oRDtrf9tRAnpJ0e+mmh6nSCIpQrtQGSyxFak=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  depsBuildBuild = [
    buildPackages.stdenv.cc
    uthash
  ];

  buildInputs = [ uthash ] ++ lib.optionals (finalAttrs.finalPackage.doCheck) [ check ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  mesonBuildType = "release";

  mesonFlags = lib.optionals (!finalAttrs.finalPackage.doCheck) [ "-Dtests=false" ];

  doCheck = true;

  meta = {
    description = "C library for reading DICOM files";
    homepage = "https://github.com/ImagingDataCommons/libdicom";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lromor ];
    platforms = lib.platforms.unix;
  };
})
