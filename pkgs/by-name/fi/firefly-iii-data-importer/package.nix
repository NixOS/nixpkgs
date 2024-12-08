{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  nodejs,
  fetchNpmDeps,
  buildPackages,
  php83,
  nixosTests,
  nix-update-script,
  dataDir ? "/var/lib/firefly-iii-data-importer",
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "firefly-iii-data-importer";
  version = "1.5.7";

  src = fetchFromGitHub {
    owner = "firefly-iii";
    repo = "data-importer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-CKDAPpDTTrBXPhfSQiBl/M42hOQi2KwpWDtEnlDwpuU=";
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

  vendorHash = "sha256-larFTf64oPJi+XLMK6ZuLEN4P/CkGLojUJDE/gvu8UU=";

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    name = "${finalAttrs.pname}-npm-deps";
    hash = "sha256-0xY9F/Bok2RQ1YWRr5fnENk3zB1WubnpT0Ldy+i618g=";
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
    npm run build --workspace=v2
  '';

  passthru = {
    phpPackage = php83;
    tests = nixosTests.firefly-iii-data-importer;
    updateScript = nix-update-script { };
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
