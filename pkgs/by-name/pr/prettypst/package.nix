{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "prettypst";
  version = "unstable-2023-12-06";

  src = fetchFromGitHub {
    owner = "antonWetzel";
    repo = "prettypst";
    rev = "bf46317ecac4331f101b2752de5328de5981eeba";
    hash = "sha256-wPayP/693BKIrHrRkx4uY0UuZRoCGPNW8LB3Z0oSBi4=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "typst-syntax-0.10.0" = "sha256-qiskc0G/ZdLRZjTicoKIOztRFem59TM4ki23Rl55y9s=";
    };
  };

  meta = {
    changelog = "https://github.com/antonWetzel/prettypst/blob/${src.rev}/changelog.md";
    description = "Formatter for Typst";
    homepage = "https://github.com/antonWetzel/prettypst";
    license = lib.licenses.mit;
    mainProgram = "prettypst";
    maintainers = with lib.maintainers; [ drupol ];
  };
}
