{
  fetchFromGitHub,
  fetchpatch,
  fetchYarnDeps,
  lib,
  nodejs,
  php85,
  php85Packages,
  stdenvNoCC,
  yarnConfigHook,
  dataDir ? "/var/lib/pelican-panel",
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pelican-panel";
  version = "1.0.0-beta33";

  src = fetchFromGitHub {
    owner = "pelican-dev";
    repo = "panel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+nP6J+ZdtWtR4bo8DQkvnS5jVbjvxITnWvwkR+izOYY=";
  };

  buildInputs = [ php85 ];

  nativeBuildInputs = [
    nodejs
    php85.composerHooks2.composerInstallHook
    php85Packages.composer
    yarnConfigHook
  ];

  composerVendor = php85.mkComposerVendor {
    inherit (finalAttrs)
      pname
      src
      version
      ;
    composerNoDev = true;
    composerNoPlugins = true;
    composerNoScripts = true;
    composerStrictValidation = true;
    strictDeps = true;
    vendorHash = "sha256-oBTmBlm31/AjPB0C0vgA94+6WMPG+IBMql3a2H+SjfQ=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-VLero9gHqkh6svauRSwZf2ASpEBu9iQcPUx+J77SR+o=";
  };

  installPhase = ''
    runHook preInstall

    yarn run build

    cp -r public/build $out/share/php/pelican-panel/public

    chmod -R u+w $out/share
    mv $out/share/php/pelican-panel/* $out/

    rm -rf $out/share $out/plugins $out/storage $out/bootstrap/cache
    ln -s ${dataDir}/.env $out/.env
    ln -s ${dataDir}/plugins $out/plugins
    ln -s ${dataDir}/bootstrap/cache $out/bootstrap/cache
    ln -s ${dataDir}/storage $out/storage

    runHook postInstall
  '';

  meta = {
    description = "Free game server control panel offering high flying security";
    changelog = "https://github.com/pelican-dev/panel/releases/tag/v${finalAttrs.version}";
    homepage = "https://pelican.dev";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ hythera ];
    platforms = lib.platforms.all;
  };
})
