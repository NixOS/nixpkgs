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
<<<<<<< HEAD
  version = "6.4.14";
=======
  version = "6.4.8";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "firefly-iii";
    repo = "firefly-iii";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-hXqLy0i1q2RRx0yg67zOPZPxEQ2c+VsFp90LFIXOE2w=";
=======
    hash = "sha256-Jk4VYGi1OYQCOiPywLOTvGeEfkbc3FuhBxSir+nTQW0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  buildInputs = [ php84 ];

  nativeBuildInputs = [
    nodejs
    nodejs.python
    buildPackages.npmHooks.npmConfigHook
<<<<<<< HEAD
    php84.packages.composer
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    php84.composerHooks2.composerInstallHook
  ];

  composerVendor = php84.mkComposerVendor {
    inherit (finalAttrs) pname src version;
<<<<<<< HEAD
    composerStrictValidation = true;
    strictDeps = true;
    vendorHash = "sha256-fLL0FAhd8r2igiZZ+wb1gse+vembHS6rzUnKe9LXXmI=";
=======
    composerNoDev = true;
    composerNoPlugins = true;
    composerNoScripts = true;
    composerStrictValidation = true;
    strictDeps = true;
    vendorHash = "sha256-DLWrYV7VTut2f5K8z3OeFF6O4csK9ibGbsz575YI+DA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    name = "${finalAttrs.pname}-npm-deps";
<<<<<<< HEAD
    hash = "sha256-kmYxC5+Vi/wCP/mT4n7JtxbzW4nVHOsA4xFpNMn0Li8=";
=======
    hash = "sha256-mOhorHUC7mWJnx6UKEl2VABlC7ZK5fA9u+B5auTLIIc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  preInstall = ''
    npm run prod --workspace=v1
    npm run build --workspace=v2
  '';

  passthru = {
    phpPackage = php84;
    tests = nixosTests.firefly-iii;
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "v(\\d+\\.\\d+\\.\\d+)"
      ];
    };
  };

  postInstall = ''
    chmod -R u+w $out/share
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
