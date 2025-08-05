{
  lib,
  rustPlatform,
  fetchFromGitea,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "core";
  version = "0-unstable-2026-10-14";
  __structuredAttrs = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "core-lang";
    repo = "core";
    rev = "40dfde5ebf2e905013efbcc905e8211d2dd46282";
    hash = "sha256-H5W72HFlaUHELOdZXO583S1rKiX6scatNOeIMyaq8FA=";
  };

  cargoHash = "sha256-3uxefbJA6IlRK8p28iR8jFSc/MVbyscywgmDINRmJio=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Compiler, runtime and standard library of Core";
    longDescription = ''
      Core is a modern programming language that uses a minimal set of
      orthogonal building blocks to ensure simplicity, readability,
      modifiability and stability.
    '';
    homepage = "https://core-lang.dev";
    changelog = "https://core-lang.dev/changes.html";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "core";
  };
}
