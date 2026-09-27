{
  lib,
  stdenv,
  autoPatchelfHook,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  nodejs,
  fetchFromGitHub,
  fetchurl,
  fetchYarnDeps,
  matrix-sdk-crypto-nodejs,
  makeWrapper,
  nixosTests,
  node-pre-gyp,
  node-gyp,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mjolnir";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "mjolnir";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xc/vrBL1rqgB69NqkEmUg7YMX4EZRFrRNPrWA7euaXU=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-qaPbSnVcrSjKz7PNG/5257cme+9iSKFYuALKGb8RZ5o=";
  };

  tfjsNative =
    {
      aarch64-linux = fetchurl {
        url = "https://storage.googleapis.com/tf-builds/libtensorflow_r2_7_linux_arm64.tar.gz";
        hash = "sha256-k5XR/zn1toR/USHmef9OWZ3HBhoqf4fOrAYceOkI5uM=";
      };
      aarch64-darwin = fetchurl {
        url = "https://storage.googleapis.com/tf-builds/libtensorflow_r2_7_darwin_arm64_cpu.tar.gz";
        hash = "sha256-E6siuX4q8G5DGq63tC+4mYGWXdAaoW2gNdghCqQYPXk=";
      };
      x86_64-linux = fetchurl {
        url = "https://storage.googleapis.com/tensorflow/libtensorflow/libtensorflow-cpu-linux-x86_64-2.9.1.tar.gz";
        hash = "sha256-f1ENJUbj214QsdEZRjaJAD1YeEKJKtPJW8pRz4KCAXM=";
      };
      x86_64-darwin = fetchurl {
        url = "https://storage.googleapis.com/tensorflow/libtensorflow/libtensorflow-cpu-darwin-x86_64-2.9.1.tar.gz";
        hash = "sha256-Vvg9MyC6D2mqr9bAWGReG3+8dfuaP8Nta+mN4SkcoiY=";
      };
    }
    ."${stdenv.hostPlatform.system}"
      or (throw "Missing tfjs support for ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [
    autoPatchelfHook
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    nodejs
    makeWrapper
    node-pre-gyp
    node-gyp
    python3
  ];

  buildInputs = [
    # Provide libstdc++
    stdenv.cc.cc
  ];

  postInstall = ''
    cp -r lib/* $out/lib/node_modules/mjolnir/lib/
    ls node_modules/@tensorflow/tfjs-node

    rm -rf $out/lib/node_modules/mjolnir/node_modules/@matrix-org/matrix-sdk-crypto-nodejs
    ln -s ${matrix-sdk-crypto-nodejs}/lib/node_modules/@matrix-org/matrix-sdk-crypto-nodejs $out/lib/node_modules/mjolnir/node_modules/@matrix-org/matrix-sdk-crypto-nodejs

    mkdir $out/lib/node_modules/mjolnir/node_modules/@tensorflow/tfjs-node/deps
    tar -xvf $tfjsNative -C $out/lib/node_modules/mjolnir/node_modules/@tensorflow/tfjs-node/deps

    cd $out/lib/node_modules/mjolnir/node_modules/@tensorflow/tfjs-node
    export CPPFLAGS="-I${lib.getDev nodejs}/include/node -Ideps/include"
    node-pre-gyp install --prefer-offline --build-from-source --nodedir=${nodejs}
    rm -rf $out/lib/node_modules/mjolnir/node_modules/@tensorflow/tfjs-node/build-tmp-napi-v8

    makeWrapper ${nodejs}/bin/node "$out/bin/mjolnir" \
      --add-flags "$out/lib/node_modules/mjolnir/lib/index.js"
  '';

  passthru = {
    tests = {
      inherit (nixosTests) mjolnir;
    };
  };

  meta = {
    description = "Moderation tool for Matrix";
    homepage = "https://github.com/matrix-org/mjolnir";
    longDescription = ''
      As an all-in-one moderation tool, it can protect your server from
      malicious invites, spam messages, and whatever else you don't want.
      In addition to server-level protection, Mjolnir is great for communities
      wanting to protect their rooms without having to use their personal
      accounts for moderation.

      The bot by default includes support for bans, redactions, anti-spam,
      server ACLs, room directory changes, room alias transfers, account
      deactivation, room shutdown, and more.

      A Synapse module is also available to apply the same rulesets the bot
      uses across an entire homeserver.
    '';
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      jojosch
      RossComputerGuy
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "mjolnir";
  };
})
