{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  nodejs,
  fetchNpmDeps,
  buildPackages,
  php84,
  nixosTests,
  dataDir ? "/var/lib/speedtest-tracker",
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "speedtest-tracker";
  version = "1.13.10";

  src = fetchFromGitHub {
    owner = "alexjustesen";
    repo = "speedtest-tracker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-X/ShdTGAb7qPqYlZ71rxGzAetPRexlaDQ4AYvwouddc=";
  };

  buildInputs = [ php84 ];

  nativeBuildInputs = [
    nodejs
    buildPackages.npmHooks.npmConfigHook
    php84.packages.composer
    php84.composerHooks2.composerInstallHook
  ];

  composerVendor = php84.mkComposerVendor {
    inherit (finalAttrs) pname src version;
    composerNoScripts = true;
    composerStrictValidation = false;
    strictDeps = true;
    vendorHash = "sha256-fS0Wstv6uHOE5WaDWSL4nbgpHCLM442zmPoER7ZRhfg=";
  };

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    name = "${finalAttrs.pname}-npm-deps";
    hash = "sha256-qWBVonPKqyB6OrDkR1ihtVac/b0Qd++Q/W4nk/VPm9E=";
  };

  preInstall = ''
    npm run build
  '';

  postInstall = ''
    chmod -R u+w $out/share
    mv $out/share/php/speedtest-tracker/* $out/
    rm -R $out/share $out/storage $out/bootstrap/cache $out/node_modules
    ln -s ${dataDir}/storage $out/storage
    ln -s ${dataDir}/cache $out/bootstrap/cache
  '';

  passthru = {
    phpPackage = php84;
    tests = nixosTests.speedtest-tracker;
  };

  meta = {
    description = "Speedtest Tracker is a self-hosted application that monitors the performance and uptime of your internet connection";
    homepage = "https://github.com/alexjustesen/speedtest-tracker";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ katexochen ];
    platforms = lib.platforms.linux;
  };
})
