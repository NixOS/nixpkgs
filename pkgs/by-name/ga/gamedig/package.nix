{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "gamedig";
  version = "5.3.3-unstable-2026-11-16";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gamedig";
    repo = "node-gamedig";
    rev = "22e455f393583c44e977e07d4a1d368bf50d3413";
    hash = "sha256-dbpiaSx0iZyjiJ9pLOjIgKEVXsUcmHxr0kp0V0TZMrQ=";
  };

  npmDepsHash = "sha256-lW3VbOqn247AT4xTHswU/p3smphjVkWtldPQikR4M04=";

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
