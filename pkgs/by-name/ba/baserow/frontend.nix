{
  pkgs,
  lib,
  stdenv,
  fetchFromGitLab,
  fetchFromGitHub,
  python3,
  fetchYarnDeps,
  prefetch-yarn-deps,
  pkg-config,
  libsass,
  nodejs_21,
  breakpointHook,
  baserow,
  fixup-yarn-lock,
}:

let
  # For Node.js 16.x: https://gitlab.com/baserow/baserow/-/issues/1714
  yarn_env = (pkgs.yarn.override { nodejs = nodejs_21; });
  node = nodejs_21;
  # Fix me for later: computation of `baserow_${modDir}` is very incorrect.
  mkBaserowFrontendModule = modDir: "${modDir}/web-frontend/modules/baserow_${modDir}/module.js";
  modules = lib.concatStringsSep "," (
    map mkBaserowFrontendModule [
      "$out/premium"
      "$out/enterprise"
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "baserow-frontend";
  inherit (baserow) version src;

  sourceRoot = "${finalAttrs.src.name}/web-frontend";

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/web-frontend/yarn.lock";
    hash = "sha256-b+xmSIyMgThYezKQnb5k8pfZ8ZurYxjvSaSrwsmin88=";
  };

  nativeBuildInputs = [
    python3
    yarn_env
    prefetch-yarn-deps
    nodejs_21
    pkg-config
    libsass
    breakpointHook
    fixup-yarn-lock
  ];

  buildPhase = ''
    runHook preBuild

    export HOME=$(mktemp -d)

    fixup-yarn-lock yarn.lock
    yarn config --offline set yarn-offline-mirror $offlineCache
    fixup-yarn-lock yarn.lock
    yarn --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive install
    patchShebangs node_modules

    mkdir -p $HOME/.node-gyp/${node.version}
    echo 9 > $HOME/.node-gyp/${node.version}/installVersion

    ln -sfv ${node}/include $HOME/.node-gyp/${node.version}
    export npm_config_nodedir=${node}

    pushd node_modules/node-sass
    LIBSASS_EXT=auto yarn run build --offline
    popd

    NUXT_TELEMETRY_DISABLED=1 yarn build-local
    cd ../

    runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out
    cp -r web-frontend $out/web-frontend
    # Built-in plugins
    mkdir -p $out/premium
    cp -r premium/web-frontend $out/premium/web-frontend
    mkdir -p $out/enterprise
    cp -r enterprise/web-frontend $out/enterprise/web-frontend
    # Wrap nuxt with `ADDITIONAL_MODULES`
    # wrapProgram $out/node_modules/.bin/nuxt \
    #  --set ADDITIONAL_MODULES "${modules}"
  '';

  distPhase = "true";

  meta = {
    inherit (baserow.meta) homepage description license maintainers;
  };
})
