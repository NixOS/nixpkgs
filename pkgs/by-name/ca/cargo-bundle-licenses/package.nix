{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-bundle-licenses";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "sstadick";
    repo = "cargo-bundle-licenses";
    rev = "v${finalAttrs.version}";
    hash = "sha256-L3hmgDwzL6lLa0LCg/V5QeNK2U1u2dJMO4+t6W1UvxI=";
  };

  cargoHash = "sha256-HHBFT4u0NPjhKJa3KNg8/AgkgNoFUkMWmioVaXYlD2M=";

  meta = {
    description = "Generate a THIRDPARTY file with all licenses in a cargo project";
    mainProgram = "cargo-bundle-licenses";
    homepage = "https://github.com/sstadick/cargo-bundle-licenses";
    changelog = "https://github.com/sstadick/cargo-bundle-licenses/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
  };
})
