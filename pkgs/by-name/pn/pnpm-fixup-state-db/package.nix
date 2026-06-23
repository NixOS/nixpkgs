{
  buildNpmPackage,
  lib,
  nodejs-slim,
  pnpm,
  tests,
}:
buildNpmPackage {
  pname = "pnpm-fixup-state-db";
  version = "1.0.0";

  src = ./src;

  nodejs = nodejs-slim;
  nativeBuildInputs = lib.optional (builtins.hasAttr "npm" nodejs-slim) nodejs-slim.npm;

  npmDepsHash = "sha256-um6a4pEtPtdxHBRq9g5ZW20wIQAMjWJ3qF96XuxJg8o=";

  postInstall = ''
    makeWrapper ${lib.getExe nodejs-slim} $out/bin/pnpm-fixup-state-db \
      --add-flags "$out/lib/node_modules/pnpm-fixup-state-db"
  '';

  passthru.tests = {
    inherit (tests) pnpm;
  };

  __structuredAttrs = true;

  meta = {
    license = lib.licenses.mit;
    mainProgram = "pnpm-fixup-state-db";
    inherit (pnpm.meta) maintainers;
  };
}
