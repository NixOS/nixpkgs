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
  version = "11.0.0";

  src = fetchFromGitHub {
    owner = "entropitor";
    repo = "dotenv-cli";
    rev = "v${version}";
    hash = "sha256-oPgi2l6YNt7WyaOzr7EkjgXOitpw9PY7tmN86bUM88Q=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
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
    changelog = "https://github.com/entropitor/dotenv-cli/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "dotenv";
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
