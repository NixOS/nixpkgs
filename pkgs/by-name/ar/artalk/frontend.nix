{
  lib,
  stdenvNoCC,
  nodejs,
  pnpmConfigHook,
  pnpm_10,
  fetchPnpmDeps,

  artalk,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "${artalk.pname}-frontend";

  inherit (artalk) src version;

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_10
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 4;
    hash = "sha256-rs3isWKlV+RGA3shYZZpNImn9xJ67vpXoJmQoO6y2cE=";
  };

  # vite-plugin-checker spawns a chokidar watcher during the build, which on
  # Darwin exhausts the file descriptor limit with native fs.watch.
  env.CHOKIDAR_USEPOLLING = lib.optionalString stdenvNoCC.hostPlatform.isDarwin "true";

  buildPhase = ''
    runHook preBuild

    pnpm build:all
    pnpm build:plugin-kit
    pnpm build:auth

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{dist/{i18n,plugins},sidebar}

    # dist
    cp ./ui/artalk/dist/{Artalk,ArtalkLite}.{css,js} $out/dist
    cp ./ui/artalk/dist/i18n/*.js $out/dist/i18n
    cp ./ui/plugin-*/dist/*.js $out/dist/plugins

    # sidebar
    cp -r ./ui/artalk-sidebar/dist/* $out/sidebar

    runHook postInstall
  '';
})
