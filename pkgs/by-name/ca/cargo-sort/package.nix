{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-sort";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "devinr528";
    repo = "cargo-sort";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-jmiCwXRyuK10qb1/7bwhOT/Cq335S9BzKiRc/02wc1E=";
  };

  cargoHash = "sha256-EzKXrN5TdWFP8zQjop2pIhavJ5a7t+YdK5s5WjwjLNM=";

  meta = {
    description = "Tool to check that your Cargo.toml dependencies are sorted alphabetically";
    mainProgram = "cargo-sort";
    homepage = "https://github.com/devinr528/cargo-sort";
    changelog = "https://github.com/devinr528/cargo-sort/blob/v${finalAttrs.version}/changelog.md";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
  };
})
