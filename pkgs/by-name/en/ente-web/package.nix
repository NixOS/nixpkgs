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
  version = "0.9.99";

  src = fetchFromGitHub {
    owner = "ente-io";
    repo = "ente";
    sparseCheckout = [ "web" ];
    tag = "photos-v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-/dWnaVll/kaKHTJ5gH18BR6JG5E6pF7/j+SgvE66b7M=";
  };
  sourceRoot = "${finalAttrs.src.name}/web";

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/web/yarn.lock";
    hash = "sha256-Wu0/YHqkqzrmA5hpVk0CX/W1wJUh8uZSjABuc+DPxMA=";
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
      surfaceflinger
      pinpox
    ];
    platforms = lib.platforms.all;
  };
})
