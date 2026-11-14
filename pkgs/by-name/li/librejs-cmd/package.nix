{
  lib,
  buildNpmPackage,
  fetchFromCodeberg,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "librejs-cmd";
  version = "0-unstable-2026-07-27";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromCodeberg {
    owner = "librejs";
    repo = "librejs-cmd";
    rev = "d63545b9bf8d550a1e485ed859c1b46468bc5d01";
    hash = "sha256-1L5zmFeOYg5RiGU/SRi7pOeh2cikQPTak8u1wyYjhs8=";
  };

  npmDepsHash = "sha256-2FQs7FGr1ZXgbwiqISv7ZYOcq9VMSLQkY9P3+jPEcgE=";
  dontNpmBuild = true;

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    npx qunit 'tests/unit/**/*.js'
    node tests/integration/test-runtime-consistency.js
    node tests/integration/test-ts-compiled.js

    runHook postCheck
  '';

  # Bun and Deno entry points would run under Node.js through the wrappers
  postInstall = ''
    rm "$out"/bin/librejs-cmd-{bun,deno}
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Command-line tool for checking GNU LibreJS compliance of JavaScript and HTML files";
    homepage = "https://codeberg.org/librejs/librejs-cmd";
    license = with lib.licenses; [
      lgpl3Plus
      # src/librejs-storage
      gpl3Plus
    ];
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "librejs-cmd";
  };
})
