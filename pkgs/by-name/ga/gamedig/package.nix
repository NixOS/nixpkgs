{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "gamedig";
  version = "unstable-2026-05-26";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gamedig";
    repo = "node-gamedig";
    rev = "11dc4af80ad31444f6c4eeb4885862b3565240e1";
    hash = "sha256-Zu6CJqOwnzyPqJY3cqys1EMXSIgJ0rAJlcZkcuQxiX0=";
  };

  npmDepsHash = "sha256-seGzkiJFXKdV+p4wp9+Azbppwm8z276Da6DFO3PFtOo=";

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
