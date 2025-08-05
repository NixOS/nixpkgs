{
  lib,
  rustPlatform,
  fetchFromGitea,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "core";
  version = "0-unstable-2025-10-12";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "core-lang";
    repo = "core";
    rev = "bee6db08cf855dc7a9dea54246ece31b6f1f3916";
    hash = "sha256-PRVYB2B3oq2WMdnmI1gr+J7QKaOEkF6TVvzPTA/M2Qs=";
  };

  cargoHash = "sha256-R7F1zlphIwdQ2zVmJOT3xQPNw/kkqDBufm/Wdx1SCM4=";

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
