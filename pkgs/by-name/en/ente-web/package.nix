{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  nodejs,
  yarnConfigHook,
  yarnBuildHook,
  nix-update-script,
  extraBuildEnv ? { },
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ente-web";
  version = "1.1.57";

  src = fetchFromGitHub {
    owner = "ente-io";
    repo = "ente";
    sparseCheckout = [ "web" ];
    tag = "photos-v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-SCkxGm/w0kES7wDuLBsUTgwrFYNLvLD51NyioAVTLrg=";
  };
  sourceRoot = "${finalAttrs.src.name}/web";

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/web/yarn.lock";
    hash = "sha256-FnLMXOpIVNOhaM7VjNEDlwpew9T/5Ch5eFed9tLpDsI=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs
  ];

  # See: https://github.com/ente-io/ente/blob/main/web/apps/photos/.env
  env = extraBuildEnv;

  installPhase = ''
    runHook preInstall

    cp -r apps/photos/out $out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "photos-v(.*)"
    ];
  };

  meta = {
    description = "Web client for Ente Photos";
    homepage = "https://ente.io/";
    changelog = "https://github.com/ente-io/ente/releases";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      pinpox
    ];
    platforms = lib.platforms.all;
  };
})
