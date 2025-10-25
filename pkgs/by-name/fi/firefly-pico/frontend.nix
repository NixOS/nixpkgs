{
  src,
  version,
  stdenvNoCC,
  nodejs,
  fetchNpmDeps,
  buildPackages,
  php84,
  nixosTests,
  nix-update-script,
  meta,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "firefly-pico-frontend";
  inherit version src;

  sourceRoot = "source/front";

  nativeBuildInputs = [
    nodejs
    nodejs.python
    buildPackages.npmHooks.npmConfigHook
  ];

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    sourceRoot = "source/front";
    name = "${finalAttrs.pname}-npm-deps";
    hash = "sha256-ryxQgnh+Rj5BoSFwKIdhFa99ziVDt4UwVMHvMeIcDSU=";
  };

  passthru = {
    phpPackage = php84;
    tests = nixosTests.firefly-pico;
    updateScript = nix-update-script { };
  };
  env.NUXT_TELEMETRY_DISABLED = 1;
  buildPhase = ''
    runHook preBuild
    npm run generate
    runHook postBuild
  '';
  postInstall = ''
    mkdir -p $out/share/firefly-pico
    cp -r .output/public $out/share/firefly-pico/
  '';

  inherit meta;
})
