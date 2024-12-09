{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  nodejs,
  yarnConfigHook,
  yarnBuildHook,
  extraBuildEnv ? { },
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ente-web";
  version = "0.9.16";

  src = fetchFromGitHub {
    owner = "ente-io";
    repo = "ente";
    sparseCheckout = [ "web" ];
    rev = "refs/tags/photos-v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-DqfUUXY79CndEqPT8TR4PasLtaSCtqZaV2kp10Vu4PQ=";
  };
  sourceRoot = "${finalAttrs.src.name}/web";

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/web/yarn.lock";
    hash = "sha256-tgFh8Av1Wl77N4hR2Y5TQp9lEH4ZCQnCIWMPmlZBlV4=";
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

  meta = {
    description = "Web client for Ente Photos";
    homepage = "https://ente.io/";
    changelog = "https://github.com/ente-io/ente/releases";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      surfaceflinger
      pinpox
    ];
    platforms = lib.platforms.all;
  };
})
