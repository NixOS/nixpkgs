{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-pgo";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "kobzol";
    repo = "cargo-pgo";
    rev = "v${version}";
    hash = "sha256-+mnpJwgu1zNnFVoA9SS9h0U1FOc3wyWjgFk8AMNNvFA=";
  };

  cargoHash = "sha256-wYarUvQX6DZCe339i2Xfg2ACnxfn6Sngoawm/uyw9wo=";

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
