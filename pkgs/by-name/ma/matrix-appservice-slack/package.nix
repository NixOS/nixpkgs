{
  lib,
  fetchFromGitHub,
  fetchYarnDeps,
  makeWrapper,
  mkYarnPackage,
  nodejs_20,
  callPackage,
}:

let
  data = lib.importJSON ./pin.json;
  nodejs = nodejs_20;
  matrix-sdk-crypto-nodejs = callPackage ./matrix-sdk-crypto-nodejs-0_1_0-beta_3/package.nix { };
in
mkYarnPackage rec {
  inherit nodejs;

  pname = "matrix-appservice-slack";
  version = data.version;

  packageJSON = ./package.json;
  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "matrix-appservice-slack";
    rev = data.version;
    hash = data.srcHash;
  };

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    sha256 = data.yarnHash;
  };
  packageResolutions = {
    "@matrix-org/matrix-sdk-crypto-nodejs" =
      "${matrix-sdk-crypto-nodejs}/lib/node_modules/@matrix-org/matrix-sdk-crypto-nodejs";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildPhase = ''
    runHook preBuild
    yarn run build
    runHook postBuild
  '';

  postInstall = ''
    makeWrapper '${nodejs}/bin/node' "$out/bin/matrix-appservice-slack" --add-flags \
        "$out/libexec/matrix-appservice-slack/deps/matrix-appservice-slack/lib/app.js"
  '';

  doDist = false;

  meta = with lib; {
    description = "Matrix <--> Slack bridge";
    mainProgram = "matrix-appservice-slack";
    maintainers = with maintainers; [
      beardhatcode
      chvp
    ];
    license = licenses.asl20;
    # Depends on nodejs_18 that has been removed.
    broken = true;
  };
}
