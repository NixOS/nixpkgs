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
  version = "27.0.0";

  src = fetchFromGitHub {
    owner = "antfu-collective";
    repo = "ni";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Yh159OpM4LPWJMO2Jv8xkzqRFurgK8EAQDyUIhWfHZ4=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-pg2zFm84sqTRM/KaNxnvtZMZHhgdrThPoMV58KKbvHA=";
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
