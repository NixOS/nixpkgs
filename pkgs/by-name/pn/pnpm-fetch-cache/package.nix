{
  buildNpmPackage,
  lib,
  nodejs-slim,
  pnpm,
  tests,
}:
buildNpmPackage {
  pname = "pnpm-fetch-cache";
  version = "1.0.0";

  src = ./src;

  nodejs = nodejs-slim;
  nativeBuildInputs = lib.optional (builtins.hasAttr "npm" nodejs-slim) nodejs-slim.npm;

  npmDepsHash = "sha256-r+GakSC6fMil4Do/cBylCjwUlxK6mq+YW9ZnbC0Kejw=";

  checkPhase = ''
    runHook preCheck

    npm run test

    runHook postCheck
  '';

  postInstall = ''
    makeWrapper ${lib.getExe nodejs-slim} $out/bin/pnpm-fetch-cache \
      --add-flags "$out/lib/node_modules/pnpm-fetch-cache"
  '';

  passthru.tests = {
    inherit (tests) pnpm;
  };

  __structuredAttrs = true;
  doCheck = true;

  meta = {
    license = lib.licenses.mit;
    mainProgram = "pnpm-fetch-deps";
    inherit (pnpm.meta) maintainers;
  };
}
