{
  lib,
  fetchFromGitHub,
  fetchzip,
  stdenvNoCC,
  nodejs-slim,
  fetchNpmDeps,
  buildPackages,
  php85,
  nixosTests,
  nix-update-script,
  dataDir ? "/var/lib/firefly-iii",
}:
let
  php = php85;
  version = "6.7.4";

  # Release tarball contains translations downloaded from crowdin
  releaseTarball = fetchzip {
    url = "https://github.com/firefly-iii/firefly-iii/releases/download/v${version}/FireflyIII-v${version}.tar.gz";
    stripRoot = false;
    hash = "sha256-ejXSfrsmHfbR5KpVo9VxXEsJWZ2ejS55JPl9P/6QzH8=";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "firefly-iii";
  inherit version;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "firefly-iii";
    repo = "firefly-iii";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Gd4AjzYRPOxFRVB6Q6RfxovSr4AaUAhWGZpUyMgw5eQ=";
  };

  buildInputs = [ php ];

  nativeBuildInputs = [
    nodejs-slim
    nodejs-slim.npm
    nodejs-slim.python
    buildPackages.npmHooks.npmConfigHook
    php.packages.composer
    php.composerHooks2.composerInstallHook
  ];

  composerVendor = php.mkComposerVendor {
    inherit (finalAttrs) pname src version;
    composerStrictValidation = true;
    strictDeps = true;
    vendorHash = "sha256-NcjnEuXHG+5c8dbBRROI8IyOKZQC/9qOACcckdUfq/g=";
  };

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    hash = "sha256-w5py4lmZDXdH8sNRkckbreUe/KmH2OKf/kzp80203gE=";
  };

  preInstall = ''
    npm run build --workspace=v3
  '';

  passthru = {
    inherit releaseTarball;
    phpPackage = php;
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

    # Copy language files from release tarball (contains all translations)
    cp -r ${finalAttrs.passthru.releaseTarball}/resources/lang/* $out/resources/lang/

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
