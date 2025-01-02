{
  lib,
  fetchFromGitHub,
  nixosTests,
  fetchYarnDeps,
  nodejs,
  php,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  nodePackages,
  python3,
  pkg-config,
  libsass,
  stdenv,
}:

php.buildComposerProject (finalAttrs: {
  pname = "invoiceplane";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "InvoicePlane";
    repo = "InvoicePlane";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-E2TZ/FhlVKZpGuczXb/QLn27gGiO7YYlAkPSolTEoeQ=";
  };

  vendorHash = "sha256-k7YBs6x/ABNTHPx9/EZXa4W9kcLQqpruV7YFGAADZq0=";

  buildInputs = [ libsass ];

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    # Needed for executing package.json scripts
    nodePackages.grunt-cli
    pkg-config
    (python3.withPackages (ps: with ps; [ distutils ]))
    stdenv.cc
  ];

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-KVlqC9zSijPP4/ifLBHD04fm6IQJpil0Gy9M3FNvUUw=";
  };

  # Upstream composer.json file is missing the name, description and license fields
  composerStrictValidation = false;

  postBuild = ''
    # Building node-sass dependency
    mkdir -p "$HOME/.node-gyp/${nodejs.version}"
    echo 9 >"$HOME/.node-gyp/${nodejs.version}/installVersion"
    ln -sfv "${nodejs}/include" "$HOME/.node-gyp/${nodejs.version}"
    export npm_config_nodedir=${nodejs}

    pushd node_modules/node-sass
    LIBSASS_EXT=auto yarn run build --offline
    popd

    # Running package.json scripts
    grunt build
  '';

  # Cleanup
  postInstall = ''
    mv $out/share/php/invoiceplane/* $out/
    rm -r $out/{composer.json,composer.lock,CONTRIBUTING.md,docker-compose.yml,Gruntfile.js,package.json,node_modules,yarn.lock,share}
  '';

  passthru.tests = {
    inherit (nixosTests) invoiceplane;
  };

  meta = {
    description = "Self-hosted open source application for managing your invoices, clients and payments";
    changelog = "https://github.com/InvoicePlane/InvoicePlane/releases/tag/v${finalAttrs.version}";
    homepage = "https://www.invoiceplane.com";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ onny ];
  };
})
