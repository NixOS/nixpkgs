{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nodejs-slim,
  pnpm,
  tests,
}:
buildNpmPackage {
  pname = "pnpm-mirror";
  version = "0-unstable-2026-10-21";

  src = fetchFromGitHub {
    owner = "Scrumplex";
    repo = "pnpm-mirror";
    rev = "2b69432f58c480c813c61e1e2af544d106cb1146";
    hash = "sha256-jyx0bZxp9/pQn2Nr1XX6oQkw7zLOw3TUkqmEDRIoGnY=";
  };

  nodejs = nodejs-slim;
  nativeBuildInputs = lib.optional (builtins.hasAttr "npm" nodejs-slim) nodejs-slim.npm;

  npmDepsHash = "sha256-VL2te+CtwhD4koK/imJbhw4kRlT+X3RWtvkM7fQs0eI=";

  checkPhase = ''
    runHook preCheck

    npm run test

    runHook postCheck
  '';

  postInstall = ''
    makeWrapper ${lib.getExe nodejs-slim} $out/bin/pnpm-mirror \
      --add-flags "$out/lib/node_modules/pnpm-mirror"
  '';

  passthru.tests = {
    inherit (tests) pnpm;
  };

  __structuredAttrs = true;
  doCheck = true;

  meta = {
    description = "Tool to generate local mirrors/caches of dependencies referenced in pnpm-lock.yaml files";
    homepage = "https://github.com/Scrumplex/pnpm-mirror";
    licenses = lib.licenses.gpl3Plus;
    mainProgram = "pnpm-mirror";
    maintainers = with lib.maintainers; [ Scrumplex ];
  };
}
