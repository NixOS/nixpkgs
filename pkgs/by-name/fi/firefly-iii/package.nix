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
  dataDir ? "/var/lib/firefly-iii",
}:

let
  php = php85;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "firefly-iii";
  version = "6.5.9";

  src = fetchFromGitHub {
    owner = "firefly-iii";
    repo = "firefly-iii";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8Orha6/cLjE9J01m77LwpvXlYrOmb/28TzxQ/RJdvDQ=";
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
    vendorHash = "sha256-9TTlMVlW7aXckIgpB5M0IxcLDtHqMboQgP00pmfK1zg=";
  };

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    name = "${finalAttrs.pname}-npm-deps";
    hash = "sha256-UyViUi/bIXK2aIzRgYe3oTyIMBRHpKYHIIEb6Qq1Jkk=";
  };

  preInstall = ''
    npm run prod --workspace=v1
    npm run build --workspace=v2
  '';

  passthru = {
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
