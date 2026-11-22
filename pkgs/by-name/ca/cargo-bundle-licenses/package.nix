{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-bundle-licenses";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "sstadick";
    repo = "cargo-bundle-licenses";
    rev = "v${finalAttrs.version}";
    hash = "sha256-j9ZqJ2V+QgFvm73lEEHyTmd7yIy/XJCMqSWr+2XtTno=";
  };

  cargoHash = "sha256-45CBzufJIKxrK4TciKGej8iEXL98Tx2CK/jD+yErJUg=";

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
