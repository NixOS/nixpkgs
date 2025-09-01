{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "rinf";
  version = "8.7.2";

  src = fetchFromGitHub {
    owner = "cunarist";
    repo = "rinf";
    rev = "v${version}";
    hash = "sha256-8H1CavEo7OU0aW6AVzSOvweD2vOmZPnLaTjPUGX4DbU=";
  };

  cargoPatches = [
    # a patch file to add/update Cargo.lock in the source code
    ./add-Cargo.lock.patch
  ];

  cargoHash = "sha256-SmPm/Dexrg8hiMBY5882+u2cktTMfA12O479oKYNBWg=";

  buildAndTestSubdir = "rust_crate_cli";

  meta = {
    description = "Rust in Flutter: Rust for native business logic, Flutter for flexible and beautiful GUI";
    mainProgram = "rinf";
    homepage = "https://rinf.cunarist.com/";
    changelog = "https://github.com/cunarist/rinf/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aljazerzen ];
  };
}
