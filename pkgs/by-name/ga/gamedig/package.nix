{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "gamedig";
  version = "unstable-2025-11-16";

  src = fetchFromGitHub {
    owner = "gamedig";
    repo = "node-gamedig";
    rev = "3f1a06638f503137a4af2084fe3b21d3e6879f2e";
    hash = "sha256-JrMLlvYU8Br9e01oAVWbSOqX6zqb1RWNJ8Afer9DuGQ=";
  };

  npmDepsHash = "sha256-SNUCjkRU+9ti5v7EpI7miU3aIc5nEAjycjk02CXdQjc=";

  meta = {
    changelog = "https://github.com/gamedig/node-gamedig/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Open Source Libraries for Game Server Queries";
    homepage = "https://gamedig.github.io";
    downloadPage = "https://github.com/gamedig/node-gamedig";
    license = lib.licenses.mit;
    mainProgram = "gamedig";
    maintainers = [ lib.maintainers.rhoriguchi ];
  };
})
