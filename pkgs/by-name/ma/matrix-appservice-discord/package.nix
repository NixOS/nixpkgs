{
  lib,
  stdenv,
  fetchYarnDeps,
  fetchFromGitHub,

  # native
  yarn,
  yarnConfigHook,
  node-gyp,
  python3,
  srcOnly,
  removeReferencesTo,
  yarnBuildHook,
  makeWrapper,

  # buildInputs
  nodejs_20,
  matrix-sdk-crypto-nodejs,
  napi-rs-cli,
}:

let
  yarn' = yarn.override {
    nodejs = nodejs_20;
  };
  yarnConfigHook' = yarnConfigHook.override {
    nodejs = nodejs_20;
    yarn = yarn';
  };
  yarnBuildHook' = yarnBuildHook.override {
    nodejs = nodejs_20;
    yarn = yarn';
  };
  matrix-sdk-crypto-nodejs' = matrix-sdk-crypto-nodejs.override {
    nodejs = nodejs_20;
    napi-rs-cli = napi-rs-cli.override {
      nodejs = nodejs_20;
    };
  };
  nodeSources = srcOnly nodejs_20;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "matrix-appservice-discord";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "matrix-appservice-discord";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UyRMMbnX4aJVv8oQfgn/rkZT1cRATtcgFj4fXszDKqo=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-s8ictJX65mSU2oxaIuCswfb2flo2RN9a1JZevacN/Ic=";
  };

  nativeBuildInputs = [
    yarnConfigHook'
    yarnBuildHook'
    nodejs_20
    node-gyp
    python3
    removeReferencesTo
    makeWrapper
  ];

  preBuild = ''
    cp -r ${matrix-sdk-crypto-nodejs'}/lib/node_modules/@matrix-org ./node_modules
    cd ./node_modules/better-sqlite3
    npm run build-release --offline --nodedir="${nodeSources}"
    find build -type f -exec remove-references-to -t "${nodeSources}" {} \;
    cd ../../
  '';

  # npmHooks.npmInstallHook and yarnInstallHook don't work for this package
  # because:
  #
  # - There is no `bin` key in
  #   package.json, which instructs it to create a binary file for the package.
  # - The build/ directory, containing the compiled `.js` files from some
  #   doesn't get picked up by `yarn pack`.
  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules

    mv build $out/lib/node_modules/matrix-appservice-discord
    cp -r node_modules $out/lib/node_modules/matrix-appservice-discord
    makeWrapper '${nodejs_20}/bin/node' "$out/bin/matrix-appservice-discord" \
      --add-flags "$out/lib/node_modules/matrix-appservice-discord/src/discordas.js"

    # admin tools wrappers
    for toolPath in $out/lib/node_modules/matrix-appservice-discord/tools/*; do
      makeWrapper '${nodejs_20}/bin/node' \
        "$out/bin/matrix-appservice-discord-$(basename $toolPath .js)" \
        --add-flags "$toolPath"
    done

    runHook postInstall
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    # the default 2000ms timeout is sometimes too short on our busy builders
    yarn --offline test --timeout 10000

    runHook postCheck
  '';

  meta = {
    description = "Bridge between Matrix and Discord";
    homepage = "https://github.com/matrix-org/matrix-appservice-discord";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ euxane ];
    platforms = lib.platforms.linux;
    mainProgram = "matrix-appservice-discord";
  };
})
