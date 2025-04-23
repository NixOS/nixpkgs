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
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "cioraneanu";
    repo = "firefly-pico";
    tag = "${finalAttrs.version}";
    hash = "sha256-5hpvXg6EjjsvKXMXzFQpJCX4FQjnhwu7eQrERN+mZhE=";
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
    vendorHash = "sha256-eVPMfIpA0PX+jOdgtscKObgi8WPtAh7CsvHsUEzzv8Q=";
  };

  passthru = {
    phpPackage = php84;
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
