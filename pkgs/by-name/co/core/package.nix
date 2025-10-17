{
  lib,
  rustPlatform,
  fetchFromGitea,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "core";
  version = "0-unstable-2025-08-05";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "core-lang";
    repo = "core";
    rev = "8d2b6ea38faa48b46b6104914c506855ffd35920";
    hash = "sha256-d+UO7339lvDkmBOkgh83WalPFMsSGhHmkB27DUgDKxg=";
  };

  cargoHash = "sha256-3CpcCDRjY958/FxzZIumnjIILfbjVzCenLAwmxyRaOM=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Compiler, runtime and standard library of Core";
    longDescription = ''
      Core is a modern programming language that uses a minimal set of
      orthogonal building blocks to ensure simplicity, readability,
      modifiability and stability.
    '';
    homepage = "https://core-lang.dev/";
    changelog = "https://core-lang.dev/changes.html";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "core";
  };
}
