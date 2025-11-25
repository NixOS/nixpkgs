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
  version = "0.1.16";
  src = fetchFromGitHub {
    owner = "OpenSiFli";
    repo = "sftool";
    tag = finalAttrs.version;
    hash = "sha256-9q19f5jH+Xx6Sv/5mBthHN6dTDz/+4VumyZcmlxHGa8=";
  };

  cargoHash = "sha256-MHHIohpUe9EOQ8GAh50Miy4hZhGM4t5gw0G0suusYT0=";

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
