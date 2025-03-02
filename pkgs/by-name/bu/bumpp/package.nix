{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  pnpm_9,
  npmHooks,
  versionCheckHook,
  nix-update-script,
}:
let
  pnpm = pnpm_9;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "bumpp";
  version = "10.0.3";

  src = fetchFromGitHub {
    owner = "antfu-collective";
    repo = "bumpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7e0p/mrGtyUO3za02d6fGS3ynF/txjieQ5w48UZooKQ=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-NztqIE/0FSeFdteCPAPm/KgrD0Ax95HKe0FwWjj9unc=";
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
  versionCheckProgramArg = [ "--version" ];
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
