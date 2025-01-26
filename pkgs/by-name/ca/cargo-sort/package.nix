{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-sort";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "devinr528";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-AUtue1xkhrhlF7PtqsCQ9rdhV0/0i85DWrp7YL9SAYk=";
  };

  cargoHash = "sha256-y6lLwk40hmFQKDU7sYz3+QQzdn5eGoEX7izmloK22dg=";

  meta = with lib; {
    description = "Tool to check that your Cargo.toml dependencies are sorted alphabetically";
    mainProgram = "cargo-sort";
    homepage = "https://github.com/devinr528/cargo-sort";
    changelog = "https://github.com/devinr528/cargo-sort/blob/v${version}/changelog.md";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [
      figsoda
      matthiasbeyer
    ];
  };
}
