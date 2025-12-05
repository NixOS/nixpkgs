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
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "ImagingDataCommons";
    repo = "libdicom";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-YaCN2QuL+yGfSYw3/wxgu9hut98UYa5tMTzTs2NGP1A=";
  };

  buildInputs = [ uthash ] ++ lib.optionals (finalAttrs.finalPackage.doCheck) [ check ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  # fix build for pkgsLLVM. Related: https://github.com/NixOS/nixpkgs/issues/265121
  depsBuildBuild = [ buildPackages.stdenv.cc ];

  mesonBuildType = "release";

  mesonFlags = lib.optionals (!finalAttrs.finalPackage.doCheck) [ "-Dtests=false" ];

  doCheck = true;

  meta = with lib; {
    description = "C library for reading DICOM files";
    homepage = "https://github.com/ImagingDataCommons/libdicom";
    license = licenses.mit;
    maintainers = with maintainers; [ lromor ];
    platforms = platforms.unix;
  };
})
