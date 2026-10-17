{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  nodejs,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "prettier-package-json";
  version = "2.7.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "cameronhunter";
    repo = "prettier-package-json";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sqvuWZ0DaeL1psL6uZdnDpxHO5naE/hKMsLqhkT7zA4=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-dCEIMzvReaLsCzxEk1CGWhD8y+hM0j5H+5ZAyn5DMeI=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    # Needed for executing package.json scripts
    nodejs
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Prettier formatter for package.json files";
    homepage = "https://github.com/cameronhunter/prettier-package-json";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "prettier-package-json";
    platforms = lib.platforms.all;
  };
})
