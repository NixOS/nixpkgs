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
  fetchzip,
}:
let
  version = "1.6.2";
  # Fetch release tarball which contains language files
  # https://github.com/InvoicePlane/InvoicePlane/issues/1170
  languages = fetchzip {
    url = "https://github.com/InvoicePlane/InvoicePlane/releases/download/v${version}/v${version}.zip";
    hash = "sha256-ME8ornP2uevvH8DzuI25Z8OV0EP98CBgbunvb2Hbr9M=";
  };
in
php.buildComposerProject2 (finalAttrs: {
  pname = "invoiceplane";
  inherit version;

  src = fetchFromGitHub {
    owner = "InvoicePlane";
    repo = "InvoicePlane";
    tag = "v${version}";
    hash = "sha256-E2TZ/FhlVKZpGuczXb/QLn27gGiO7YYlAkPSolTEoeQ=";
  };

  vendorHash = "sha256-eq3YKIZZzZihDYgFH3YTETHvNG6hAE/oJ5Ul2XRMn4U=";

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

  # Cleanup and language files
  postInstall = ''
    chmod -R u+w $out/share
    mv $out/share/php/invoiceplane/* $out/
    cp -r ${languages}/application/language $out/application/
    rm -r $out/{composer.json,composer.lock,CONTRIBUTING.md,docker-compose.yml,Gruntfile.js,package.json,node_modules,yarn.lock,share}
  '';

  passthru.tests = {
    inherit (nixosTests) invoiceplane;
  };

  meta = {
    description = "Self-hosted open source application for managing your invoices, clients and payments";
    changelog = "https://github.com/InvoicePlane/InvoicePlane/releases/tag/v${version}";
    homepage = "https://www.invoiceplane.com";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ onny ];
  };
})
