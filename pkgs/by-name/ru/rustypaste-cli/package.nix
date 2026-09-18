{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustypaste-cli";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "rustypaste-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ALv+3ZcU5oX3nROB86G5vyT7rO/DiU/akyP+lWXDQwc=";
  };

  cargoHash = "sha256-2nwtzOJ1VzXSm0u82vjFop9IkPJJ4hlrBXFVUm6RH9Q=";

  meta = {
    description = "CLI tool for rustypaste";
    homepage = "https://github.com/orhun/rustypaste-cli";
    changelog = "https://github.com/orhun/rustypaste-cli/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.matthiasbeyer ];
    mainProgram = "rpaste";
  };
})
