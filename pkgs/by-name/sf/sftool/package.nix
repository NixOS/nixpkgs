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
  version = "0.1.14";
  src = fetchFromGitHub {
    owner = "OpenSiFli";
    repo = "sftool";
    tag = finalAttrs.version;
    hash = "sha256-xheGgtE9hZVNa4ceqQCrfiYJwlIuXm00J//0VeZ/afE=";
  };

  cargoHash = "sha256-pimr4OL709EWIoLk/Wq+QAiveLyR/V70nPuzYfZSH/o=";

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
    maintainers = with lib.maintainers; [ eihqnh ];
    mainProgram = "sftool";
  };
})
