{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  pnpm_10,
  npmHooks,
  versionCheckHook,
  nix-update-script,
}:
let
  pnpm = pnpm_10;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ni";
  version = "27.0.1";

  src = fetchFromGitHub {
    owner = "antfu-collective";
    repo = "ni";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rl0pzzhQCuX3Vvq7Iu88L4ph3nA8HRD8HU11YGXT1wQ=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-M0SbUWoIHWftfpHPYmX/sUmvR8pGmONv4HUVos6x72I=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
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
  versionCheckProgramArg = "--version";
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
