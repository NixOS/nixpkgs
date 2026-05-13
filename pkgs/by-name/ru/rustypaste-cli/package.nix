{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustypaste-cli";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "rustypaste-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7SuX7abFrQegELvlwFRvt7yRmNWq1egIzYIkAvG4eQQ=";
  };

  cargoHash = "sha256-aEvkRI467cE2S3q4uIHypclhVk9X/GXi3MiLsxPgANQ=";

  meta = {
    description = "CLI tool for rustypaste";
    homepage = "https://github.com/orhun/rustypaste-cli";
    changelog = "https://github.com/orhun/rustypaste-cli/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.matthiasbeyer ];
    mainProgram = "rpaste";
  };
})
