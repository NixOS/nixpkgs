{
  nixosTests,
  fetchFromGitHub,
  fetchYarnDeps,
  lib,
  nodejs,
  php85,
  php85Packages,
  stdenvNoCC,
  yarnConfigHook,
  nix-update-script,
  dataDir ? "/var/lib/pelican-panel",
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  name = "${finalAttrs.pname}-${finalAttrs.version}";

  pname = "pelican-panel";
  version = "1.0.0-rc.2";

  src = fetchFromGitHub {
    owner = "pelican";
    repo = "panel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m2WMlQBdH3M1uBXtIzWtYx+60ho3ZFBH9ssHlEOu2vA=";
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
      name
      pname
      src
      version
      ;
    strictDeps = true;
    vendorHash = "sha256-5BGQX6dXv8lEIVGi5so71jmbMM5sDYFQFlX67XgkiDs=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-EVbyxhZhe6rKYY65HrU0fqE6m/tzKY7mjdgYvDDj8po=";
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

  strictDeps = true;
  __structuredAttrs = true;

  passthru = {
    php = php85;
    updateScript = nix-update-script {
      extraArgs = [ "--version=unstable" ];
    };

    tests = {
      inherit (nixosTests) pelican-panel;
    };
  };

  meta = {
    description = "Free game server control panel offering high flying security";
    changelog = "https://github.com/pelican/panel/releases/tag/v${finalAttrs.version}";
    homepage = "https://pelican.dev";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      oskardotglobal
      Svenum
      keenanweaver
      nullcube
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
