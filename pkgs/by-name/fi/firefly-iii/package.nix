{ lib
, fetchFromGitHub
, stdenvNoCC
, nodejs
, fetchNpmDeps
, buildPackages
, php83
, nixosTests
, nix-update-script
, dataDir ? "/var/lib/firefly-iii"
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "firefly-iii";
  version = "6.1.24";

  src = fetchFromGitHub {
    owner = "firefly-iii";
    repo = "firefly-iii";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ZB0yaGHL1AI67i2ixUzuWyiBjXJNlDV4APBahDuNObI=";
  };

  buildInputs = [ php83 ];

  nativeBuildInputs = [
    nodejs
    nodejs.python
    buildPackages.npmHooks.npmConfigHook
    php83.composerHooks.composerInstallHook
    php83.packages.composer-local-repo-plugin
  ];

  composerNoDev = true;
  composerNoPlugins = true;
  composerNoScripts = true;
  composerStrictValidation = true;
  strictDeps = true;

  vendorHash = "sha256-6sOmW+CFuNEBVHpZwh/wjrIINPdcPJUvosmdLaCvZlw=";

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    name = "${finalAttrs.pname}-npm-deps";
    hash = "sha256-W3lV0LbmOPfIwStNf4IwBVorSFHIlpyuIk+17/V/Y2Y=";
  };

  composerRepository = php83.mkComposerRepository {
    inherit (finalAttrs)
      pname
      src
      vendorHash
      version
      ;
    composerNoDev = true;
    composerNoPlugins = true;
    composerNoScripts = true;
    composerStrictValidation = true;
  };

  preInstall = ''
    npm run prod --workspace=v1
    npm run build --workspace=v2
  '';

  passthru = {
    phpPackage = php83;
    tests = nixosTests.firefly-iii;
    updateScript = nix-update-script { };
  };

  postInstall = ''
    mv $out/share/php/firefly-iii/* $out/
    rm -R $out/share $out/storage $out/bootstrap/cache $out/node_modules
    ln -s ${dataDir}/storage $out/storage
    ln -s ${dataDir}/cache $out/bootstrap/cache
  '';

  meta = {
    changelog = "https://github.com/firefly-iii/firefly-iii/releases/tag/v${finalAttrs.version}";
    description = "Firefly III: a personal finances manager";
    homepage = "https://github.com/firefly-iii/firefly-iii";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.savyajha lib.maintainers.patrickdag ];
    hydraPlatforms = lib.platforms.linux; # build hangs on both Darwin platforms, needs investigation
  };
})
