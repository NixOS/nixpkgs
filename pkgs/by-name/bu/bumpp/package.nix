{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
<<<<<<< HEAD
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm,
=======
  pnpm_10,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  npmHooks,
  versionCheckHook,
  nix-update-script,
}:
<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "bumpp";
  version = "10.3.2";
=======
let
  pnpm = pnpm_10;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "bumpp";
  version = "10.3.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "antfu-collective";
    repo = "bumpp";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-1hGVLPogdeyWh/B2Yxfo/9YbJpFYl8ATh+QCa2VVyyk=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-y7uHDtoOjsLnNF47r4aWHYXW0ui8shhn1M0cD2FpaCg=";
=======
    hash = "sha256-krJzPHlGgtEukOlSX0sXfCwXmdItDLhf6hS+zamNrN4=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-N6boJiwq5G4L/vOqp+GoYWtSI1sYScYadxXueeJgGMo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    nodejs
<<<<<<< HEAD
    pnpmConfigHook
    pnpm
=======
    pnpm.configHook
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
