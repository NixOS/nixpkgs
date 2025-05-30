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
  version = "9.7.0";

  src = fetchFromGitHub {
    owner = "carloscuesta";
    repo = "gitmoji-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2nQCxmZdDMKHcmVihloU4leKRB9LRBO4Q5AINR1vdCQ=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-YemcF7hRg+LAkR3US1xAgE0ELAeZTVLhscOphjmheRI=";
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
