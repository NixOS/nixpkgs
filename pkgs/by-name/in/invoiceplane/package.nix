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
  version = "1.6.3";
  # Fetch release tarball which contains language files
  # https://github.com/InvoicePlane/InvoicePlane/issues/1170
  languages = fetchzip {
    url = "https://github.com/InvoicePlane/InvoicePlane/releases/download/v${version}/v${version}.zip";
    hash = "sha256-MuqxbkayW3GeiaorxfZSJtlwCWvnIF2ED/UUqahyoIQ=";
  };
in
php.buildComposerProject2 (finalAttrs: {
  pname = "invoiceplane";
  inherit version;

  src = applyPatches {
    src = fetchFromGitHub {
      owner = "InvoicePlane";
      repo = "InvoicePlane";
      tag = "v${version}";
      hash = "sha256-XNjdFWP5AEulbPZcMDXYSdDhaLWlgu3nnCSFnjUjGpk=";
    };
    patches = [
      # Fix composer.json validation
      # See https://github.com/InvoicePlane/InvoicePlane/pull/1306
      ./fix_composer_validation.patch
    ];
  };

  patches = [
    # yarn.lock missing some resolved attributes and fails
    ./fix-yarn-lock.patch
  ];

  vendorHash = "sha256-UCYAnECuIbIYg1T4I8I9maXVKXJc1zkyauBuIy5frTY=";

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    # Needed for executing package.json scripts
    nodePackages.grunt-cli
  ];

  offlineCache = fetchYarnDeps {
    inherit (finalAttrs) src patches;
    hash = "sha256-0fPdxOIeQBTulPUxHtaQylm4jevQTONSN1bChqbGbGs=";
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
