{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm,
  npmHooks,
  versionCheckHook,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ni";
  version = "29.0.0";

  src = fetchFromGitHub {
    owner = "antfu-collective";
    repo = "ni";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PRYsKIpjb3Mu+U1Vc4eHx07LHZt7DycEkb/AFsi/OgA=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-zYKsg9tMaiclazKkiE8EIKRJFwePEwChsvFOs9bp1jE=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
    npmHooks.npmInstallHook
  ];

  buildPhase = ''
    runHook preBuild

    pnpm run build
    find dist -type f \( -name '*.cjs' -or -name '*.cts' -or -name '*.ts' \) -delete

    runHook postBuild
  '';

  dontNpmPrune = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Use the right package manager";
    homepage = "https://github.com/antfu-collective/ni";
    changelog = "https://github.com/antfu-collective/ni/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
    mainProgram = "ni";
  };
})
