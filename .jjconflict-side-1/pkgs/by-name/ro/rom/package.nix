{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rom";
  version = "0.3.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "manic-systems";
    repo = "rom";
    tag = "v${finalAttrs.version}";
    hash = "sha256-c/LlexaefKTbAoz85ehO6h21S/nI3piszZZMIsUNDDk=";
  };

  cargoHash = "sha256-92cikSkMicuSv8eK7J6J8BEnjnxKNQmKtVCS5OPGyhM=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Flamboyant output monitor for the Nix build tool";
    homepage = "https://github.com/manic-systems/rom";
    changelog = "https://github.com/manic-systems/rom/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [
      faukah
      amaanq
      NotAShelf
      qweered
    ];
    mainProgram = "rom";
  };
})
