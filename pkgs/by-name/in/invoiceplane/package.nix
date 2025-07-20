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

  patches = [
    # Node-sass is deprecated and fails to cross-compile
    # See: https://github.com/InvoicePlane/InvoicePlane/issues/1275
    ./node_switch_to_sass.patch
  ];

  vendorHash = "sha256-eq3YKIZZzZihDYgFH3YTETHvNG6hAE/oJ5Ul2XRMn4U=";

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    # Needed for executing package.json scripts
    nodePackages.grunt-cli
  ];

  offlineCache = fetchYarnDeps {
    inherit (finalAttrs) src patches;
    hash = "sha256-qAm4HnZwfwfjv7LqG+skmFLTHCSJKWH8iRDWFFebXEs=";
  };

  # Upstream composer.json file is missing the name, description and license fields
  composerStrictValidation = false;

  postBuild = ''
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
