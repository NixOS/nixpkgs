{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "gamedig";
  version = "unstable-2026-04-23";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gamedig";
    repo = "node-gamedig";
    rev = "8504291b8041cd9efd7a1cea6be3292fc3e1ebe5";
    hash = "sha256-GBJLozTGKztd1sSAH6W6MKpI2cJPgFUpGQd5GUvHa2A=";
  };

  npmDepsHash = "sha256-1LxSIn+vSr/tD3fAEq5byuaaaX0ibbjN+7YJ1abJnQk=";

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
