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
  version = "1.7.2";
  # Fetch release tarball which contains language files
  # https://github.com/InvoicePlane/InvoicePlane/issues/1170
  languages = fetchzip {
    url = "https://github.com/InvoicePlane/InvoicePlane/releases/download/v${version}/v${version}.zip";
    hash = "sha256-DpQazuLOJnNGrrQo7l6uQReoKZEd5es2DT0a50NuQB0=";
  };
in
php.buildComposerProject2 (finalAttrs: {
  pname = "invoiceplane";
  # unstable-2026-09-28 version syntax not supported here
  version = "1.7.2.1";

  src = fetchFromGitHub {
    owner = "InvoicePlane";
    repo = "InvoicePlane";
    rev = "a934e27e6c0961ac96d4b8c19baf6e17c03beb1f";
    hash = "sha256-Nh0F0IGiY25g2MvuEdLs/p2oIAJuni116KKwzyVSa9c=";
  };

  # Composer.lock validation currently fails for unknown reason
  composerStrictValidation = true;

  vendorHash = "sha256-bkPoUd+u1wKM+CpbrbmD8lT6zyMKf/vx6km5kzo9s5Q=";

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    # Needed for executing package.json scripts
    grunt-cli
  ];

  offlineCache = fetchYarnDeps {
    inherit (finalAttrs) src patches;
    hash = "sha256-faEq9sVsE5xcqL07IIEmXcavcWPZicb7asmuhuBI+h4=";
  };

  postBuild = ''
    grunt build
  '';

  # Cleanup and language files
  postInstall = ''
    chmod -R u+w $out/share
    mv $out/share/php/invoiceplane/* $out/
    cp -r ${languages}/application/language $out/application/
    rm -r $out/{composer.json,composer.lock,docker-compose.yml,Gruntfile.js,package.json,node_modules,yarn.lock,share}
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
