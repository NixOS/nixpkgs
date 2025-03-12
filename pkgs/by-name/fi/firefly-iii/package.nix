{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  nodejs,
  fetchNpmDeps,
  buildPackages,
  php84,
  nixosTests,
  nix-update-script,
  dataDir ? "/var/lib/firefly-iii",
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "firefly-iii";
  version = "6.2.6";

  src = fetchFromGitHub {
    owner = "firefly-iii";
    repo = "firefly-iii";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JMBnlWQ1dtib3vjF9US9RAegINF+NLqgPhJIkYjZm9A=";
  };

  buildInputs = [ php84 ];

  nativeBuildInputs = [
    nodejs
    nodejs.python
    buildPackages.npmHooks.npmConfigHook
    php84.composerHooks.composerInstallHook
    php84.packages.composer-local-repo-plugin
  ];

  composerNoDev = true;
  composerNoPlugins = true;
  composerNoScripts = true;
  composerStrictValidation = true;
  strictDeps = true;

  vendorHash = "sha256-Fpv9bqUz60ZFij3wk5h6uRfDU9uJlb/OIdcDuMyFGdo=";

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    name = "${finalAttrs.pname}-npm-deps";
    hash = "sha256-k17rcJxmttLMspKiX/j0Oeo5uvFcCqhHN7kxLsod1Xc=";
  };

  composerRepository = php84.mkComposerRepository {
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
    phpPackage = php84;
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
    maintainers = [
      lib.maintainers.savyajha
      lib.maintainers.patrickdag
    ];
    hydraPlatforms = lib.platforms.linux; # build hangs on both Darwin platforms, needs investigation
  };
})
