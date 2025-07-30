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
stdenv.mkDerivation rec {
  pname = "dotenv-cli";
  version = "9.0.0";

  src = fetchFromGitHub {
    owner = "entropitor";
    repo = "dotenv-cli";
    rev = "v${version}";
    hash = "sha256-mpVObsilwVCq1V2Z11uqK1T7VgwpfTYng2vqrTqJZE4=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-ak6QD9Z0tE0XgFVt3QkjZxk2kelUFPX9bEF855RiY2w=";
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
    changelog = "https://github.com/entropitor/dotenv-cli/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "dotenv";
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
