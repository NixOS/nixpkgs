{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "matugen";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "InioX";
    repo = "matugen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2jcqAU8QutF8AE15LYwd8cy7KjayGxUGHxvWnqAiS5M=";
  };

  cargoHash = "sha256-RlzY0eaYrEVkO7ozzgfLHxKB2jy4nSYda9Z0jrqiUVA=";

  meta = {
    description = "Material you color generation tool";
    homepage = "https://github.com/InioX/matugen";
    changelog = "https://github.com/InioX/matugen/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ lampros ];
    mainProgram = "matugen";
  };
})
