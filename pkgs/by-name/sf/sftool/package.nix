{
  lib,
  pkg-config,
  rustPlatform,
  stdenv,
  systemdLibs,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sftool";
  version = "0.2.3";
  src = fetchFromGitHub {
    owner = "OpenSiFli";
    repo = "sftool";
    tag = finalAttrs.version;
    hash = "sha256-W7ndWXwhXuY5w299njDONgmkRWmvHxX0hBYW/+yVp38=";
  };

  cargoHash = "sha256-STOL4spLNxdXv3jUov9qMg9ToYzK7aQpT31xy/aec2k=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    systemdLibs # libudev-sys
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Download tool for the SiFli family of chips";
    homepage = "https://github.com/OpenSiFli/sftool";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "sftool";
    hasNoMaintainersButDependents = true;
  };
})
