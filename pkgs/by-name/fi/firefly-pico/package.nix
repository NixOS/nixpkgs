{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  nodejs,
  callPackage,
  php84,
  nixosTests,
  nix-update-script,
  dataDir ? "/var/lib/firefly-pico",
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "firefly-pico";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "cioraneanu";
    repo = "firefly-pico";
    tag = "${finalAttrs.version}";
    hash = "sha256-Ef64WZYAtViW5lCSCtTzjs6KJL7BxW9innqLSy0N2xQ=";
  };
  sourceRoot = "source/back";

  buildInputs = [ php84 ];

  nativeBuildInputs = [
    nodejs
    nodejs.python
    php84.composerHooks2.composerInstallHook
  ];

  composerVendor = php84.mkComposerVendor {
    inherit (finalAttrs) pname src version;
    sourceRoot = "source/back";
    composerNoDev = true;
    composerNoPlugins = true;
    composerNoScripts = true;
    composerStrictValidation = true;
    strictDeps = true;
    vendorHash = "sha256-hwbmsvD91lX/vYa1Xk1WEo8pB6b+DTRDVd2DJ7TjocI=";
  };

  passthru = {
    phpPackage = php84;
    tests = nixosTests.firefly-pico;
    updateScript = nix-update-script { };
    frontend = callPackage ./frontend.nix {
      inherit (finalAttrs)
        src
        version
        meta
        ;
    };
  };
  postInstall = ''
    chmod +x $out/share/php/firefly-pico/artisan
    rm -R $out/share/php/firefly-pico/{storage,bootstrap/cache}
    ln -s ${dataDir}/storage $out/share/php/firefly-pico/storage
    ln -s ${dataDir}/cache $out/share/php/firefly-pico/bootstrap/cache
  '';

  meta = {
    changelog = "https://github.com/cioraneanu/firefly-pico/releases/tag/${finalAttrs.version}";
    description = "Delightful Firefly III companion web app for effortless transaction tracking";
    homepage = "https://github.com/cioraneanu/firefly-pico";
    license = lib.licenses.agpl3Only;
    maintainers = [
      lib.maintainers.patrickdag
    ];
    hydraPlatforms = lib.platforms.all;
  };
})
