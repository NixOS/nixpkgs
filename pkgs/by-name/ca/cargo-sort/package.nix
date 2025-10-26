{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-sort";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "devinr528";
    repo = "cargo-sort";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Ad4arLpD8tgNDUGHKBbIKt41oQfjMgzzyWnnw8Cjw0k=";
  };

  cargoHash = "sha256-BnBo0oEZL5Ilqw/AJzDITkg388LjN+8/AwxRDHQt/9s=";

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
