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

let
  pname = "firefly-iii-data-importer";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "firefly-iii";
    repo = "data-importer";
    rev = "v${version}";
    hash = "sha256-5hIH/XDyPn6CokqEO/35Xu+K9KTVYyC2jxADCU69uxI=";
  };
in

stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname src version;

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

  vendorHash = "sha256-uClTcT6qZSN2UNop4+T0c3GNozASCUk6enMfYPmzsz8=";

  npmDeps = fetchNpmDeps {
    inherit src;
    name = "${pname}-npm-deps";
    hash = "sha256-AdSPHK9Ws/VMqzuvfbShdAl1va65G1K0N379JS4Az5E=";
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
    mv $out/share/php/firefly-iii-data-importer/* $out/
    rm -R $out/share $out/storage $out/bootstrap/cache $out/node_modules
    ln -s ${dataDir}/storage $out/storage
    ln -s ${dataDir}/cache $out/bootstrap/cache
  '';

  meta = {
    changelog = "https://github.com/firefly-iii/data-importer/releases/tag/v${version}";
    description = "Firefly III Data Importer can import data into Firefly III.";
    homepage = "https://github.com/firefly-iii/data-importer";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.savyajha ];
  };
})
