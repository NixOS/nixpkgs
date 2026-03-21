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
  version = "0.2.2";
  src = fetchFromGitHub {
    owner = "OpenSiFli";
    repo = "sftool";
    tag = finalAttrs.version;
    hash = "sha256-pWECmFzxOLhmiascyK1yS/uzZ3O/MVze/cRNgE01ptY=";
  };

  cargoHash = "sha256-mvL102oT4WxpEEplxSu6uxp+odLHFB3n6mBcztXXmRA=";

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
  };
})
