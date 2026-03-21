{
  lib,
  fetchFromGitHub,
  nixosTests,
  fetchYarnDeps,
  php,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  grunt-cli,
  fetchzip,
}:
let
  version = "1.7.1";
  # Fetch release tarball which contains language files
  # https://github.com/InvoicePlane/InvoicePlane/issues/1170
  languages = fetchzip {
    url = "https://github.com/InvoicePlane/InvoicePlane/releases/download/v${version}/v${version}.zip";
    hash = "sha256-DpQazuLOJnNGrrQo7l6uQReoKZEd5es2DT0a50NuQB0=";
  };
in
php.buildComposerProject2 (finalAttrs: {
  pname = "invoiceplane";
  inherit version;

  src = fetchFromGitHub {
    owner = "InvoicePlane";
    repo = "InvoicePlane";
    tag = "v${version}";
    hash = "sha256-Nci5GaCMYIjewq0W5emE6TDgc6JPz4bVVF3okNtHUag=";
  };

  # Composer.lock validation currently fails for unknown reason
  composerStrictValidation = true;

  vendorHash = "sha256-adKvKWo55SSbEKpgMJzR9vJQA8DnNXOTfSzp7t8s2Nk=";

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    # Needed for executing package.json scripts
    grunt-cli
  ];

  offlineCache = fetchYarnDeps {
    inherit (finalAttrs) src patches;
    hash = "sha256-rJlOYMnzFKui+caIFD4d82Q/RcDYnadeJ1G56fcNNQY=";
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
