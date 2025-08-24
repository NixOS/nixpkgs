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
  version = "0-unstable-2025-07-21";

  src = fetchFromGitHub {
    owner = "sammycage";
    repo = "plutofilter";
    rev = "761d6d348dd56e094335ca82325e7b4f5ff698e5";
    hash = "sha256-RgpzNOjy9FV0e5jgNz46Ueb7xLNoWHsX+mSG/LUNtX4=";
  };

  outputs = [
    "out"
    "dev"
  ];

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
