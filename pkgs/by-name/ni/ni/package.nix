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
  pname = "ni";
  version = "28.0.0";
=======
let
  pnpm = pnpm_10;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ni";
  version = "27.0.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "antfu-collective";
    repo = "ni";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-ka+p789qFCyFDFiNQYtcwhihCB05Bbw6/6dgBrR00xg=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-0hxjX5bSqeOU9QNqusUd8L/0hoGsq4LQCr+9+5zrsaA=";
=======
    hash = "sha256-rl0pzzhQCuX3Vvq7Iu88L4ph3nA8HRD8HU11YGXT1wQ=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-M0SbUWoIHWftfpHPYmX/sUmvR8pGmONv4HUVos6x72I=";
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
    description = "Use the right package manager";
    homepage = "https://github.com/antfu-collective/ni";
    changelog = "https://github.com/antfu-collective/ni/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
    mainProgram = "ni";
  };
})
