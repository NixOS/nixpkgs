{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nodejs-slim,
  tests,
}:
buildNpmPackage {
  pname = "pnpm-mirror";
  version = "0-unstable-2026-11-01";

  src = fetchFromGitHub {
    owner = "Scrumplex";
    repo = "pnpm-mirror";
    rev = "2dff77ebc097d4117db47d81835eb8ed271718ec";
    hash = "sha256-82N6BCz7sk/+iOIbkOLA1zd1X5UI8yfbkbTkicH7krE=";
  };

  nodejs = nodejs-slim;
  nativeBuildInputs = lib.optional (builtins.hasAttr "npm" nodejs-slim) nodejs-slim.npm;

  npmDepsHash = "sha256-GVumes1iqylFHBOvP2MarGgqNYmKzQbECaYe38a7Huw=";

  checkPhase = ''
    runHook preCheck

    CI=true npm run test

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
    license = lib.licenses.gpl3Plus;
    mainProgram = "pnpm-mirror";
    maintainers = with lib.maintainers; [ Scrumplex ];
  };
}
