{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "gamedig";
  version = "unstable-2026-02-18";

  src = fetchFromGitHub {
    owner = "gamedig";
    repo = "node-gamedig";
    rev = "b8e6bd858b76c41f5177e115e27303aab8e3ecb9";
    hash = "sha256-BPOt7XOavCoTMK11zTQcnmSaHnVhJQ9br9FVClSVenY=";
  };

  npmDepsHash = "sha256-Q3LBDmAL3E/yMJqteD7X+zMTiWtKK2Un9q1z+yCBypo=";

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
