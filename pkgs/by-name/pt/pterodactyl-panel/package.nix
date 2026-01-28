{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  php83,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs_24,
  dataDir ? "/var/lib/pterodactyl-panel",
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pterodactyl-panel";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "pterodactyl";
    repo = "panel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8DthHZqlNisNeYGVM0Hsxa0ml4sfoM3v5fqAPhNZCrU=";
  };

  buildInputs = [ php83 ];
  nativeBuildInputs = [
    nodejs_24
    yarnConfigHook
    yarnBuildHook
    php83.packages.composer
    php83.composerHooks2.composerInstallHook
  ];

  composerVendor = php83.mkComposerVendor {
    inherit (finalAttrs) pname src version;
    composerNoDev = true;
    composerNoPlugins = true;
    composerNoScripts = true;
    composerStrictValidation = true;
    strictDeps = true;
    vendorHash = "sha256-mR09x1YPMkCMjGE0xGkZz0bIFXtOPhs7bS9QTbkx3XE=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-YJDf+uQ4/x+m+7yBOJ4roUuEXjrZ8EDGNyeghBQcGtE=";
  };

  env.NODE_OPTIONS = "--openssl-legacy-provider";
  yarnBuildScript = "build:production";

  installPhase = ''
    runHook preInstall

    chmod -R u+w $out/share
    mv $out/share/php/pterodactyl-panel/* $out/

    rm -rf $out/share $out/storage $out/bootstrap/cache $out/node_modules
    ln -s ${dataDir}/storage $out/storage
    ln -s ${dataDir}/bootstrap/cache $out/bootstrap/cache
    ln -s ${dataDir}/.env $out/.env

    runHook postInstall
  '';

  meta = {
    description = "Free, open-source game server management panel";
    homepage = "https://pterodactyl.io";
    changelog = "https://github.com/pterodactyl/panel/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ padowyt2 ];
    platforms = lib.platforms.all;
  };
})
