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
  pname = "coc-toml";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "kkiyama117";
    repo = "coc-toml";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iyQRa4h23mfmCmujNYYV8Y+82+HLYUtXgBzU1dtovYc=";
  };

  nativeBuildInputs = [
    yarnBuildHook
    yarnConfigHook
    yarnInstallHook
    nodejs
  ];

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-jZZUrpi3Bg4qQ/NyUDPW7zNuUz/399wAf+gdeZHp+B0=";
  };

  meta = {
    description = "Toml extension for coc.nvim";
    homepage = "https://github.com/kkiyama117/coc-toml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soopyc ];
  };
})
