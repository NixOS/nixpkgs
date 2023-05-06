{ stdenv, fetchYarnDeps, fixup_yarn_lock, callPackage, nodejs_16 }:
let
  common = callPackage ./common.nix { };
in
stdenv.mkDerivation {
  pname = "tandoor-recipes-frontend";
  inherit (common) version;

  src = "${common.src}/vue";

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${common.src}/vue/yarn.lock";
    sha256 = common.yarnSha256;
  };

  nativeBuildInputs = [
    fixup_yarn_lock
    # Use Node JS 16 because of @achrinza/node-ipc@9.2.2
    nodejs_16
    nodejs_16.pkgs.yarn
  ];

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror "$yarnOfflineCache"
    fixup_yarn_lock yarn.lock
    command -v yarn
    yarn install --frozen-lockfile --offline --no-progress --non-interactive
    patchShebangs node_modules/

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -R ../cookbook/static/vue/ $out
    cp webpack-stats.json $out
    echo "${common.version}" > "$out/version"

    runHook postInstall
  '';

  meta = common.meta // {
    description = "Tandoor Recipes frontend";
  };
}
