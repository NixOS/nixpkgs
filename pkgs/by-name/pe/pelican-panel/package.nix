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
  version = "1.0.0-beta38";

  src = fetchFromGitHub {
    owner = "pelican";
    repo = "panel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fjY2nHYpSMKBGn+VHb5hsuKcerSy/efp0WenL5yIStQ=";
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
    composerNoDev = true;
    composerNoPlugins = true;
    composerNoScripts = true;
    composerStrictValidation = true;
    strictDeps = true;
    vendorHash = "sha256-tMrWSrN6SldljK69k4SDvehNnOxPrJXfCSk761IAREg=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-GppIwYUMM7RHO7KR/PLDVK4pRm86I/MvPuHH/wg6Q9U=";
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
    changelog = "https://github.com/pelican/panel/releases/tag/v${finalAttrs.version}";
    homepage = "https://pelican.dev";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ oskardotglobal ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };

  passthru = {
    php = php85;
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^v(.*-beta.*)$"
        "--version=unstable"
      ];
    };

    tests = {
      inherit (nixosTests) pelican-panel;
    };
  };

  strictDeps = true;
  __structuredAttrs = true;
})
