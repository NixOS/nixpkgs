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
  dataDir ? "/var/lib/firefly-iii-data-importer",
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "firefly-iii-data-importer";
  version = "1.7.6";

  src = fetchFromGitHub {
    owner = "firefly-iii";
    repo = "data-importer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2QjflXnusdqg63S1RgSbDsYHk9U4Xjf59wkvvo9n+Zo=";
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

  vendorHash = "sha256-j0KjjmaDyFBFWnz6e4Bkrb3gkitfSKsj9UB2j/G19do=";

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    name = "${finalAttrs.pname}-npm-deps";
    hash = "sha256-4bDSEGg5vGoam1PLRfaxJK0aQ+MLBTF+GP0AZQjHvVw=";
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
    npm run build --workspace=v2
  '';

  passthru = {
    phpPackage = php84;
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
    description = "Firefly III Data Importer can import data into Firefly III.";
    homepage = "https://github.com/firefly-iii/data-importer";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.savyajha ];
  };
})
