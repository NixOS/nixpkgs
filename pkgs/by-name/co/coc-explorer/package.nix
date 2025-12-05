{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  nodejs,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "coc-explorer";
  version = "0.27.3";

  src = fetchFromGitHub {
    owner = "weirongxu";
    repo = "coc-explorer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lIJloatVEKPM36GE/xpVk+cx8Jz89BWU8qsNjc1eoFw=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-w2La2GTJfHjn6qaVQaHsQp8V2KNx2hqDVuBJUYk6WKg=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    nodejs
  ];

  yarnBuildScript = "build:pack";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Explorer for coc.nvim";
    homepage = "https://github.com/weirongxu/coc-explorer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
