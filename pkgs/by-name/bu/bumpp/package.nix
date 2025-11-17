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
  version = "10.3.1";

  src = fetchFromGitHub {
    owner = "antfu-collective";
    repo = "bumpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-krJzPHlGgtEukOlSX0sXfCwXmdItDLhf6hS+zamNrN4=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-N6boJiwq5G4L/vOqp+GoYWtSI1sYScYadxXueeJgGMo=";
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
