{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-pgo";
  version = "0.2.9";

  src = fetchFromGitHub {
    owner = "kobzol";
    repo = "cargo-pgo";
    rev = "v${version}";
    hash = "sha256-FmZllibhesZY/8kIMnx4VfQrYF6+/cai7Gozda/3bMY=";
  };

  cargoHash = "sha256-uOwWCSXxxnMCFS0+aFPUHSiSWSwNZPtL8NJVCCCDzAc=";

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
