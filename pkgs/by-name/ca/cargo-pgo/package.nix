{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-pgo";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "kobzol";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-u3kWYPLJYarwwudRpeBdJglP9kNbLRTYgEvZT2pBBoY=";
  };

  cargoHash = "sha256-Peicupa2vFDzPCH0OQYk7plkWIn82o45oGutOyMlI2s=";

  # Integration tests do not run in Nix build environment due to needing to
  # create and build Cargo workspaces.
  doCheck = false;

  meta = with lib; {
    description = "Cargo subcommand for optimizing Rust binaries/libraries with PGO and BOLT";
    homepage = "https://github.com/kobzol/cargo-pgo";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ dannixon ];
  };
}
