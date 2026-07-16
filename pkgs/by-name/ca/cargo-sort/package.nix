{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-sort";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "devinr528";
    repo = "cargo-sort";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-PtBjs+mqrz9z6tkpajx/OYQATJP81vi4ColjFXr9Rv0=";
  };

  cargoHash = "sha256-ygMtfhwoUEIZx+q6KB5yOr8/Fj5FRMIs7dXlYDUKb2U=";

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
