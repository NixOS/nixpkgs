{
  lib,
  fetchFromGitHub,
  nixosTests,
  fetchYarnDeps,
  applyPatches,
  php,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  nodePackages,
  fetchzip,
}:
let
  # composer doesn't support our unstable version format
  # version = "0-unstable-2025-10-05";
  version = "0";
  # Fetch release tarball which contains language files
  # https://github.com/InvoicePlane/InvoicePlane/issues/1170
  languages = fetchzip {
    #url = "https://github.com/InvoicePlane/InvoicePlane/releases/download/v${version}/v${version}.zip";
    url = "https://github.com/InvoicePlane/InvoicePlane/releases/download/v1.6.3/v1.6.3.zip";
    hash = "sha256-MuqxbkayW3GeiaorxfZSJtlwCWvnIF2ED/UUqahyoIQ=";
  };
in
php.buildComposerProject2 (finalAttrs: {
  pname = "invoiceplane";
  inherit version;

  src = fetchFromGitHub {
    owner = "InvoicePlane";
    repo = "InvoicePlane";
    #tag = "v${version}";
    rev = "62434db8505f4afea82a86a3de677ecd8bdb38ef";
    hash = "sha256-rZANX5t+umciiCSvB5adkfIEkifzeCr6cXrHBjodI88=";
  };

  vendorHash = "sha256-GIuQR+fBcbtmoZFStFgeJd8DDUnpYcjjnxSRRKRao5I=";

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    # Needed for executing package.json scripts
    nodePackages.grunt-cli
  ];

  offlineCache = fetchYarnDeps {
    inherit (finalAttrs) src patches;
    hash = "sha256-QuD1Wh4WnEwGGQzDwJQI1oqKlGZINnOL961KNnXhps4=";
  };

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
