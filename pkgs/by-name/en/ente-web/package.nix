{ lib
, stdenv
, fetchFromGitHub
, fetchYarnDeps
, nodejs
, yarnConfigHook
, yarnBuildHook
, extraBuildEnv ? null
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ente-web";
  version = "0.9.16";

  src =
    fetchFromGitHub
      {
        owner = "ente-io";
        repo = "ente";
        sparseCheckout = [ "web" ];
        rev = "photos-v${finalAttrs.version}";
        fetchSubmodules = true;
        hash = "sha256-DqfUUXY79CndEqPT8TR4PasLtaSCtqZaV2kp10Vu4PQ=";
      }
    + "/web";

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-tgFh8Av1Wl77N4hR2Y5TQp9lEH4ZCQnCIWMPmlZBlV4=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs
  ];

  # See: https://github.com/ente-io/ente/blob/main/web/apps/photos/.env
  env = lib.optionals (extraBuildEnv != null) extraBuildEnv;

  installPhase = ''
    cp -r apps/photos/out $out
  '';

  meta = {
    description = "Web client for Ente Photos";
    homepage = "https://ente.io/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      surfaceflinger
      pinpox
    ];
    platforms = lib.platforms.all;
  };
})
