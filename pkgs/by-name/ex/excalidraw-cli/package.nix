{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchPnpmDeps,
  nodejs,
  pnpm_11,
  pnpmBuildHook,
  pnpmConfigHook,
  npmHooks,
  util-linux,
  versionCheckHook,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "excalidraw-cli";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "excalidraw";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZZu6xFh0C2GmrnKsBi08vlg9yCjNpetB81pveOKP2pE=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_11;
    fetcherVersion = 4;
    hash = "sha256-74UpK2waLl5bAt3SS8vcT/35sDZtRUhR0U9xtF9t9Wc=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpmBuildHook
    pnpm_11
    npmHooks.npmInstallHook
  ];

  doCheck = true;
  __darwinAllowLocalNetworking = true;
  nativeCheckInputs = [ util-linux ];
  checkPhase = ''
    runHook preCheck

    pnpm test

    runHook postCheck
  '';

  preInstall = ''
    CI=true pnpm prune --prod --ignore-scripts
  '';

  dontNpmPrune = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Manage Excalidraw workspace resources through the public API and render scenes locally as PNG";
    homepage = "https://github.com/excalidraw/cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ davinci42 ];
    mainProgram = "excalidraw";
    platforms = nodejs.meta.platforms;
  };
})
