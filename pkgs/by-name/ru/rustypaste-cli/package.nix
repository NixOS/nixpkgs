{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustypaste-cli";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "rustypaste-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tv5nAs5g7NWVakKUyw5PVxHJYQniV9OYm7yDXhooWU4=";
  };

  cargoHash = "sha256-Z8rybofRp4hzTbn3iT0X50fcJCn2tT3HTYTLLWTJBek=";

  meta = {
    description = "CLI tool for rustypaste";
    homepage = "https://github.com/orhun/rustypaste-cli";
    changelog = "https://github.com/orhun/rustypaste-cli/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.matthiasbeyer ];
    mainProgram = "rpaste";
  };
})
