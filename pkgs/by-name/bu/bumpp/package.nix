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
  pname = "bumpp";
  version = "10.2.3";

  src = fetchFromGitHub {
    owner = "antfu-collective";
    repo = "bumpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NVu8CpfW7YXTSOEZMhhF46tgh98lAL4LYVjzml4G3MQ=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-GJEnZDPU4MNWUHM8YFB87F+JozV0fIsJSjShudV79XE=";
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
    description = "Interactive CLI that bumps your version numbers and more";
    homepage = "https://github.com/antfu-collective/bumpp";
    changelog = "https://github.com/antfu-collective/bumpp/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
    mainProgram = "bumpp";
  };
})
