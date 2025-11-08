{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-sort";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "devinr528";
    repo = "cargo-sort";
    rev = "v${version}";
    sha256 = "sha256-mdvaRTcs2zVXKX8LrqHFrWTdnFZpAfQuWjYmeWgdGVI=";
  };

  cargoHash = "sha256-FoFzBf24mNDTRBfFyTEr9Q7sJjUhs0X/XWRGEoierQ4=";

  meta = {
    description = "Tool to check that your Cargo.toml dependencies are sorted alphabetically";
    mainProgram = "cargo-sort";
    homepage = "https://github.com/devinr528/cargo-sort";
    changelog = "https://github.com/devinr528/cargo-sort/blob/v${version}/changelog.md";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
  };
}
