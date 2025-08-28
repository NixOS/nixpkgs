{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  fixup-yarn-lock,
  nodejs,
  nodejs-slim,
  matrix-sdk-crypto-nodejs,
  nixosTests,
  nix-update-script,
  yarn,
}:

let
  pname = "matrix-appservice-irc";
  version = "3.0.5";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "matrix-appservice-irc";
    tag = version;
    hash = "sha256-R/Up4SNWl2AAaeyPJe6OOKFrwIOIvDw/guJxgBuZNC4=";
  };

  yarnOfflineCache = fetchYarnDeps {
    name = "${pname}-${version}-offline-cache";
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-EJJyGVM4WMVQFWcTjgKHvRFWn40sXNi/vg/bypJ1hMU=";
  };

in
stdenv.mkDerivation {
  inherit
    pname
    version
    src
    yarnOfflineCache
    ;

  strictDeps = true;

  nativeBuildInputs = [
    fixup-yarn-lock
    nodejs-slim
    yarn
    nodejs.pkgs.node-gyp-build
  ];

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror "$yarnOfflineCache"
    fixup-yarn-lock yarn.lock
    yarn install --frozen-lockfile --offline --no-progress --non-interactive --ignore-scripts
    patchShebangs node_modules/ bin/

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp package.json $out
    cp app.js config.schema.yml $out
    cp -r bin lib public $out

    # prune dependencies to production only
    yarn install --frozen-lockfile --offline --no-progress --non-interactive --ignore-scripts --production
    cp -r node_modules $out

    # replace matrix-sdk-crypto-nodejs with nixos package
    rm -rv $out/node_modules/@matrix-org/matrix-sdk-crypto-nodejs
    ln -sv ${matrix-sdk-crypto-nodejs}/lib/node_modules/@matrix-org/matrix-sdk-crypto-nodejs $out/node_modules/@matrix-org/

    runHook postInstall
  '';

  passthru.tests.matrix-appservice-irc = nixosTests.matrix-appservice-irc;
  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/matrix-org/matrix-appservice-irc/releases/tag/${version}";
    description = "Node.js IRC bridge for Matrix";
    mainProgram = "matrix-appservice-irc";
    maintainers = with lib.maintainers; [ rhysmdnz ];
    homepage = "https://github.com/matrix-org/matrix-appservice-irc";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
  };
}
