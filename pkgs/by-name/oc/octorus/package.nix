{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "octorus";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "ushironoko";
    repo = "octorus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-20HVES8XgZEgKIijTzo9rV5IRfhyZlY1noX6yHSUf8g=";
  };

  cargoHash = "sha256-4HHl3SIXqfWOeKFmGqXLTC9veglMAFo1MLJIR/BYr0M=";

  nativeBuildInputs = [ installShellFiles ];

  meta = {
    description = "TUI PR review tool for GitHub";
    homepage = "https://github.com/ushironoko/octorus";
    changelog = "https://github.com/ushironoko/octorus/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
    mainProgram = "octorus";
  };
})
