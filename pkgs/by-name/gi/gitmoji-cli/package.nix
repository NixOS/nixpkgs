{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  nodejs,
  versionCheckHook,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gitmoji-cli";
  version = "9.6.0";

  src = fetchFromGitHub {
    owner = "carloscuesta";
    repo = "gitmoji-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-LhqwC7F0745KFzGHw9WUkPYxhIkFEmCPTxS1fuZKVHQ=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-/O+UMOYn3dBgy2uBBCeg4vHzC+fXA+7fj7Xk03miZSA=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    # Needed for executing package.json scripts
    nodejs
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/gitmoji";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Gitmoji client for using emojis on commit messages";
    homepage = "https://github.com/carloscuesta/gitmoji-cli";
    changelog = "https://github.com/carloscuesta/gitmoji-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "gitmoji";
    maintainers = with lib.maintainers; [
      nequissimus
      yzx9
    ];
  };
})
