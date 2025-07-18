{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs_20,
  makeWrapper,
  callPackage,
}:

let
  nodejs = nodejs_20;
  matrix-sdk-crypto-nodejs = callPackage ./matrix-sdk-crypto-nodejs-0_1_0-beta_3/package.nix { };
in
stdenv.mkDerivation rec {
  pname = "matrix-appservice-slack";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "matrix-appservice-slack";
    rev = version;
    hash = "sha256-e9k+5xvgHkVt/fKAr0XhYjbEzHYwdGRdqiPWWbT0T5M=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs
    yarnConfigHook
    yarnBuildHook
  ];

  postPatch = ''
    # upstream locks the supported node version range down, which we don't want
    substituteInPlace package.json \
      --replace-fail '"node": ">=16 <=18"' '"node": ">=16"'
  '';

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-fw4gXh4wfzHFgUYiEAvbhVrjno/E70iMhdk60F3Oxgg=";
  };

  preBuild = ''
    # matrix-sdk-crypto-nodejs needs rust to be built from source, which we can achieve in a separate derivation

    # first, we ensure the separately built module's version is actually the same as the version in the lockfile
    diff ${matrix-sdk-crypto-nodejs}/lib/node_modules/@matrix-org/matrix-sdk-crypto-nodejs/package.json node_modules/@matrix-org/matrix-sdk-crypto-nodejs/package.json

    # then we copy it into node_modules
    rm -r node_modules/@matrix-org/matrix-sdk-crypto-nodejs
    ln -s ${matrix-sdk-crypto-nodejs}/lib/node_modules/@matrix-org/matrix-sdk-crypto-nodejs node_modules/@matrix-org/matrix-sdk-crypto-nodejs
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"/libexec
    cp -r . "$out"/libexec/matrix-appservice-slack

    makeWrapper '${lib.getExe nodejs}' "$out/bin/matrix-appservice-slack" --add-flags \
        "$out/libexec/matrix-appservice-slack/lib/app.js"

    runHook postInstall
  '';

  passthru = {
    inherit matrix-sdk-crypto-nodejs;
  };

  meta = with lib; {
    description = "Matrix <--> Slack bridge";
    mainProgram = "matrix-appservice-slack";
    maintainers = with maintainers; [
      beardhatcode
      chvp
    ];
    license = licenses.asl20;
  };
}
