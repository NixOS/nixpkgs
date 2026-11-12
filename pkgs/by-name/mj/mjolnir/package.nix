{
  lib,
  stdenv,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  nodejs_22,
  fetchFromGitHub,
  fetchYarnDeps,
  matrix-sdk-crypto-nodejs,
  makeWrapper,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mjolnir";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "mjolnir";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PWPtp1KVOBNH7lu99Yy3hmj8wGOZe+YKjPq/SyO7oLM=";
  };

  patches = [
    # TODO: Fix tfjs-node dependency
    ./001-disable-nsfwprotection.patch
  ];

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-M4gsuzSxKOIDPL4J2HnveRDjviB0RPBmLVYBlTVz788=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    nodejs_22
    makeWrapper
  ];

  postInstall = ''
    cp -r lib/* $out/lib/node_modules/mjolnir/lib/

    rm -rf $out/lib/node_modules/mjolnir/node_modules/@matrix-org/matrix-sdk-crypto-nodejs
    ln -s ${matrix-sdk-crypto-nodejs}/lib/node_modules/@matrix-org/matrix-sdk-crypto-nodejs $out/lib/node_modules/mjolnir/node_modules/@matrix-org/matrix-sdk-crypto-nodejs

    makeWrapper ${nodejs_22}/bin/node "$out/bin/mjolnir" \
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
    maintainers = with lib.maintainers; [ jojosch ];
    mainProgram = "mjolnir";
  };
})
