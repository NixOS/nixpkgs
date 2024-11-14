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
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "coc-css";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "neoclide";
    repo = "coc-css";
    rev = finalAttrs.version;
    hash = "sha256-ASFg5LM1NbpK+Df1TPs+O13WmZktw+BtfsCJagF5nUc=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-JJXpsccO9MZ0D15JUZtTebX1zUMgwGEzSOm7auw5pQo=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs
    yarnInstallHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Css language server extension for coc.nvim";
    homepage = "https://github.com/neoclide/coc-css";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
