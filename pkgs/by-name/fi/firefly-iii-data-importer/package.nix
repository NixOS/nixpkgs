{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  nodejs-slim,
  fetchNpmDeps,
  buildPackages,
  php85,
  nixosTests,
  nix-update-script,
  dataDir ? "/var/lib/firefly-iii-data-importer",
}:

let
  php = php85;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "firefly-iii-data-importer";
  version = "2.3.5";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "firefly-iii";
    repo = "data-importer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lXPuVuYxIIoDM1gcfdRcCvwUmD3+uArgan3wY4q1cMw=";
  };

  buildInputs = [ php ];

  nativeBuildInputs = [
    nodejs-slim
    nodejs-slim.npm
    nodejs-slim.python
    buildPackages.npmHooks.npmConfigHook
    php.composerHooks.composerInstallHook
    php.packages.composer-local-repo-plugin
  ];

  composerNoDev = true;
  composerNoPlugins = true;
  composerNoScripts = true;
  composerStrictValidation = true;
  strictDeps = true;

  vendorHash = "sha256-X440UAEKEGQUeywMr4zE1bW1Sdx9DAECyvUXDjJeljs=";

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    name = "${finalAttrs.pname}-npm-deps";
    hash = "sha256-45SItCuL1RO8kIZtYI/vt0wQyfQRBcb7nY5ECYEeybQ=";
  };

  composerRepository = php.mkComposerRepository {
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
    npm run build --workspace=v2
  '';

  passthru = {
    phpPackage = php;
    tests = nixosTests.firefly-iii-data-importer;
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "v(\\d+\\.\\d+\\.\\d+)"
      ];
    };
  };

  postInstall = ''
    rm -R $out/share/php/firefly-iii-data-importer/{storage,bootstrap/cache,node_modules}
    mv $out/share/php/firefly-iii-data-importer/* $out/
    rm -R $out/share
    ln -s ${dataDir}/storage $out/storage
    ln -s ${dataDir}/cache $out/bootstrap/cache
  '';

  meta = {
    changelog = "https://github.com/firefly-iii/data-importer/releases/tag/v${finalAttrs.version}";
    description = "Firefly III Data Importer can import data into Firefly III";
    homepage = "https://github.com/firefly-iii/data-importer";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.savyajha ];
  };
})
