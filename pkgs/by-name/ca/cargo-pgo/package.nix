{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-pgo";
  version = "0.2.10";

  src = fetchFromGitHub {
    owner = "kobzol";
    repo = "cargo-pgo";
    rev = "v${version}";
    hash = "sha256-kYdEFUifpBlbEcFnDELu8OwvS46eeJQSU/6VyLQD2mk=";
  };

  cargoHash = "sha256-sY4UUGbTzw5dlALzQ6Iyo3hxB3Qni4infZRexHcle3I=";

  # Integration tests do not run in Nix build environment due to needing to
  # create and build Cargo workspaces.
  doCheck = false;

  meta = {
    description = "Cargo subcommand for optimizing Rust binaries/libraries with PGO and BOLT";
    homepage = "https://github.com/kobzol/cargo-pgo";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ dannixon ];
  };
}
