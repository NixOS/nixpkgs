{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stash-clipboard";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "NotAShelf";
    repo = "stash";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PEW28BocOhKylJXbFMSbAMJyrJW7JOeKmYVhlhrCQFc=";
  };

  cargoHash = "sha256-gEGuSe/WyxvwYic4BfnCFpRCnMN44n6DX3s0Aer4zBI=";

  meta = {
    description = "Wayland clipboard manager with fast persistent history and multi-media support";
    homepage = "https://github.com/NotAShelf/stash";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      NotAShelf
      fazzi
    ];
    mainProgram = "stash";
  };
})
