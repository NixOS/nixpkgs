{
  lib,
  stdenv,
  fetchYarnDeps,
  fetchFromGitHub,
  yarnConfigHook,
  npmHooks,
  nodejs,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "dotenv-cli";
  version = "11.1.0";

  src = fetchFromGitHub {
    owner = "entropitor";
    repo = "dotenv-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-09FQvqGSdsfSgPNengKoiqUVcfmq3LzHgdsw87SR9sE=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-I/DzRBETcusE4YS3nC47I1igsVzophNXoVtcD+upZPc=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    npmHooks.npmInstallHook
    nodejs
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI to load dotenv files";
    homepage = "https://github.com/entropitor/dotenv-cli";
    changelog = "https://github.com/entropitor/dotenv-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "dotenv";
    maintainers = with lib.maintainers; [ kamadorueda ];
  };
})
