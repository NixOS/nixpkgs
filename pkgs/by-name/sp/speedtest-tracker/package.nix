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
  version = "1.14.1";

  src = fetchFromGitHub {
    owner = "alexjustesen";
    repo = "speedtest-tracker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YI/LHTynR9AiC1MhXdO788imIUB/XndXozIepXkeuyc=";
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
    vendorHash = "sha256-Xu8Zsz5FkXiyotOZRwA9KPMHapMThmQQdVdanRGzaJc=";
  };

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    name = "${finalAttrs.pname}-npm-deps";
    hash = "sha256-Ys3hCLLjoIrno9ztSh/m2xz1HiTn20g3Vu/Pnymy/Fc=";
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
