{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  nodejs,
  nix-update-script,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "remod";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "samuela";
    repo = "remod";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-7tLxvh/pLlt3Y+PkNF0s5f/wh/wGdeDtt0dc4eQqWlw=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-94i1wduLWCGHZNoohhBfjt3i2qsWr6UznKLHXH4im+c=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    # Needed for executing package.json scripts
    nodejs
  ];

  yarnBuildScript = "prepare";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/samuela/remod/releases/tag/v${finalAttrs.version}";
    description = "chmod for human beings!";
    homepage = "https://github.com/samuela/remod";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
    mainProgram = "remod";
  };
})
