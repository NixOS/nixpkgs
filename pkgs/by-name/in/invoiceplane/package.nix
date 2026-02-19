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
  grunt-cli,
  fetchzip,
}:
let
  version = "1.7.0";
  # Fetch release tarball which contains language files
  # https://github.com/InvoicePlane/InvoicePlane/issues/1170
  languages = fetchzip {
    #url = "https://github.com/InvoicePlane/InvoicePlane/releases/download/v${version}/v${version}.zip";
    url = "https://github.com/InvoicePlane/InvoicePlane/releases/download/v1.7.0/v1.7.0.zip";
    hash = "sha256-D5wZg745xjbBsEPUbvle8ynErFB4xn9zdxOGh0xKCCU=";
  };
in
php.buildComposerProject2 (finalAttrs: {
  pname = "invoiceplane";
  inherit version;

  src = fetchFromGitHub {
    owner = "InvoicePlane";
    repo = "InvoicePlane";
    tag = "v${version}";
    hash = "sha256-6fuUmXe8mFSnLYwQCwBzxmSQxM06rQXe00IKUZvWnpM=";
  };

  # Fixes error: Couldn't find any versions for "sass" that matches "^1.97" in our cache
  patches = [ ./fix-yarn-lockfile.patch ];

  # Composer.lock validation currently fails for unknown reason
  composerStrictValidation = false;

  vendorHash = "sha256-/fNVq3WJCr9f/NE0s1x8N48W3ZMRUxdh1Qf3pLl0Lpg=";

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    # Needed for executing package.json scripts
    grunt-cli
  ];

  offlineCache = fetchYarnDeps {
    inherit (finalAttrs) src patches;
    hash = "sha256-YDknkQzdRKRRMXS6/cPRSrfhhIyTIDRnFPNGQueu74A=";
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
