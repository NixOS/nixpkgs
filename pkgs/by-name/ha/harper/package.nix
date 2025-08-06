{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "harper";
  version = "0.55.0";

  src = fetchFromGitHub {
    owner = "Automattic";
    repo = "harper";
    rev = "v${version}";
    hash = "sha256-lqN6TW78jCfn8HUBrkf7R7FV8iFEAoeycBVsUgggZHw=";
  };

  buildAndTestSubdir = "harper-ls";

  cargoHash = "sha256-befFgoP1bZSH9hqrLs9MCK2YkwJb4kK4h09I5y6qmzM=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Grammar Checker for Developers";
    homepage = "https://github.com/Automattic/harper";
    changelog = "https://github.com/Automattic/harper/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      pbsds
      sumnerevans
    ];
    mainProgram = "harper-ls";
  };
}
