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
  version = "7.4.3";

  src = fetchFromGitHub {
    owner = "entropitor";
    repo = "dotenv-cli";
    rev = "v${version}";
    hash = "sha256-kR9LSHvbvKLuJBGrsmYMeqF3s8SF+/99OeNlKp9azI8=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-Sx5DHUAXquqMqJgvhvHcRPqkfWN49+6icUQIos6OHCg=";
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
