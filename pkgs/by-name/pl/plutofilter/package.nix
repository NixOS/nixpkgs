{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  testers,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "plutofilter";
  version = "0-unstable-2025-08-02";

  src = fetchFromGitHub {
    owner = "sammycage";
    repo = "plutofilter";
    rev = "73026ecc2b4c1ec22d9fc395003689b351a750b8";
    hash = "sha256-FQbKsDB27E45K9lVnKDN0gr4bxn/mcNm0EK2w6QzrqM=";
  };

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
  ];

  doCheck = true;

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version=branch=main" ]; };
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "single-header, zero-allocation image filter library";
    homepage = "https://github.com/sammycage/plutofilter";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    pkgConfigModules = [ "plutofilter" ];
    maintainers = with lib.maintainers; [
      RossSmyth
    ];
  };
})
