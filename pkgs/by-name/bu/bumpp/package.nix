{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  fetchPnpmDeps,
  pnpmConfigHook,
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
  version = "12.2.0";

  src = fetchFromGitHub {
    owner = "antfu-collective";
    repo = "bumpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AMi4qMYU1BRfLaoGHAv3VcBxeYc+TNhvWBLH+npwiUU=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-SQekkSUsVlrtqtqwQrEu6fQc9bQ6j9Wixd3TWcbbYMg=";
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
    description = "Interactive CLI that bumps your version numbers and more";
    homepage = "https://github.com/antfu-collective/bumpp";
    changelog = "https://github.com/antfu-collective/bumpp/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
    mainProgram = "bumpp";
  };
})
