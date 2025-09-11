{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "harper";
  version = "0.62.0";

  src = fetchFromGitHub {
    owner = "Automattic";
    repo = "harper";
    rev = "v${version}";
    hash = "sha256-rtd/cuTy5n89NZtZf+lbP7jGySYjUnOfgzfziMYg+40=";
  };

  buildAndTestSubdir = "harper-ls";

  cargoHash = "sha256-ZSyAnlekjBGb0SJW4Ae1EEGwSnsDWXVUfYA0d87Ug1w=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Grammar Checker for Developers";
    homepage = "https://github.com/Automattic/harper";
    changelog = "https://github.com/Automattic/harper/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      pbsds
      sumnerevans
      ddogfoodd
    ];
    mainProgram = "harper-ls";
  };
}
