{
  lib,
  fetchFromGitHub,
  makeBinaryWrapper,
  nodejs,
  matrix-sdk-crypto-nodejs,
  python3,
  sqlite,
  srcOnly,
  removeReferencesTo,
  fetchYarnDeps,
  stdenv,
  cctools,
  nixosTests,
  yarnBuildHook,
  yarnConfigHook,
  yarnInstallHook,
  nix-update-script,
}:
let
  nodeSources = srcOnly nodejs;
in

stdenv.mkDerivation rec {
  pname = "draupnir";
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "the-draupnir-project";
    repo = "Draupnir";
    tag = "v${version}";
    hash = "sha256-PJg+ybWe7mtLgqrBZP0xKeKWc2FPv7koyjsHyK5uRKs=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    sqlite
    python3
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    nodejs
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin cctools.libtool;

  offlineCache = fetchYarnDeps {
    inherit src;
    hash = "sha256-EZ8dVRfzAFr8wepLuS90YHvAi9BA+4etVz+Vji+bQVA=";
  };

  preBuild = ''
    # install proper version info
    echo "${version}-nix" > version.txt

    # makes network requests
    sed -i 's/corepack //g' package.json
  '';

  postBuild = ''
    yarn --offline run copy-assets
  '';

  postInstall = ''
    # Replace matrix-sdk-crypto-nodejs with nixpkgs version
    nodeCryptoPath="$out/lib/node_modules/draupnir/node_modules/@matrix-org/matrix-sdk-crypto-nodejs"
    rm -rf "$nodeCryptoPath"
    cp -r ${matrix-sdk-crypto-nodejs}/lib/node_modules/@matrix-org/matrix-sdk-crypto-nodejs \
      "$nodeCryptoPath"
    chmod -R a+rx "$nodeCryptoPath"

    # build better-sqlite3
    betterSqlitePath="$out/lib/node_modules/draupnir/node_modules/better-sqlite3"
    pushd "$betterSqlitePath"
    npm run build-release --offline --nodedir="${nodeSources}"
    rm -rf build/Release/{.deps,obj,obj.target,test_extension.node}
    find build -type f -exec \
          ${lib.getExe removeReferencesTo} -t "${nodeSources}" {} \;
    popd


    # Copy files it doesn't copy for some reason
    rm -rf $out/lib/node_modules/draupnir/lib
    mv ./lib ./version.txt $out/lib/node_modules/draupnir

    # Create wrapper executable
    makeWrapper ${lib.getExe nodejs} $out/bin/draupnir \
      --add-flags $out/lib/node_modules/draupnir/lib/index.js
  '';

  passthru = {
    tests = { inherit (nixosTests) draupnir; };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Moderation tool for Matrix";
    homepage = "https://github.com/the-draupnir-project/Draupnir";
    longDescription = ''
      As an all-in-one moderation tool, it can protect your server from
      malicious invites, spam messages, and whatever else you don't want.
      In addition to server-level protection, Draupnir is great for communities
      wanting to protect their rooms without having to use their personal
      accounts for moderation.

      The bot by default includes support for bans, redactions, anti-spam,
      server ACLs, room directory changes, room alias transfers, account
      deactivation, room shutdown, and more.

      A Synapse module is also available to apply the same rulesets the bot
      uses across an entire homeserver.
    '';
    license = licenses.afl3;
    maintainers = with maintainers; [ RorySys ];
    mainProgram = "draupnir";
  };
}
