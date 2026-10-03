{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  pnpm_11,
  fetchPnpmDeps,
  pnpmConfigHook,
  npmHooks,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ghost-cli";
  version = "1.32.5";

  src = fetchFromGitHub {
    owner = "TryGhost";
    repo = "Ghost-CLI";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NYKkMIHON/82UMV7vNruZabSZez7GofcB3txwjm6USI=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_11;
    fetcherVersion = 4;
    hash = "sha256-zfjTTw94ODKZ81Hse0RyX/yhxB5ob2NgqWCmUA+kbkU=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_11
    npmHooks.npmInstallHook
  ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    pnpm exec vitest run \
      extensions/nginx/test/migrations-spec.js \
      extensions/nginx/test/extension-spec.js

    runHook postCheck
  '';

  preInstall = ''
    CI=true pnpm --ignore-scripts --prod prune

    # https://github.com/pnpm/pnpm/issues/3645
    find node_modules -xtype l -delete

    # Remove build-directory references from pnpm metadata.
    rm node_modules/{.modules.yaml,.pnpm-workspace-state-v1.json}
  '';

  # Production dependencies are pruned with pnpm above.
  dontNpmPrune = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/ghost";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "CLI Tool for installing & updating Ghost";
    mainProgram = "ghost";
    homepage = "https://ghost.org/docs/ghost-cli/";
    changelog = "https://github.com/TryGhost/Ghost-CLI/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cything ];
  };
})
