{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-sort";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "devinr528";
    repo = "cargo-sort";
    rev = "v${version}";
    sha256 = "sha256-OFDEM/qYIaWsjHKZhf/kmJo7drY+649gpe4VSE18sXc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-nQ1g0rBWx7yHQO9U/J0/XI76quEAvpCyhZDcTJKYYXo=";

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
      figsoda
      matthiasbeyer
    ];
  };
}
