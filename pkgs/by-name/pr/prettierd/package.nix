{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  nodejs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "prettierd";
  version = "0.25.3";

  src = fetchFromGitHub {
    owner = "fsouza";
    repo = "prettierd";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-3lvFZ5/p+1kPnHIR2PlQtCY3SVo1rs8IuBigLaabxAE=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-Ti2b102pzUKB6Xy3LwZ7DlrnW0cRscgNLTUIAKz+6Us=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    nodejs
  ];

  meta = {
    mainProgram = "prettierd";
    description = "Prettier, as a daemon, for improved formatting speed";
    homepage = "https://github.com/fsouza/prettierd";
    license = lib.licenses.isc;
    changelog = "https://github.com/fsouza/prettierd/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [
      NotAShelf
      n3oney
    ];
  };
})
