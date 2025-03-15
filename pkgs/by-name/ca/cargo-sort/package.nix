{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-sort";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "devinr528";
    repo = "cargo-sort";
    rev = "v${version}";
    sha256 = "sha256-fqmyL4ZSz+nKfUIrcrfLRT9paEas5d00Y/kvEqyz2vw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-z5YT+6fU12WrByu3NZwodU9Y5489eCRrHUY+H/Hka+c=";

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
