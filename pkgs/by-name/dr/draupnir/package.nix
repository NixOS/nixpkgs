{
  lib,
  fetchFromGitHub,
  makeBinaryWrapper,
  nodejs_22,
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
  nix-update-script,
}:
let
  nodeSources = srcOnly nodejs_22;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "draupnir";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "the-draupnir-project";
    repo = "Draupnir";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j5UEW9JpIHhFWGMEwrPE1v0hdFAw5Z4CImRYEm56I4k=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    sqlite
    python3
    yarnConfigHook
    yarnBuildHook
    nodejs_22
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin cctools.libtool;

  offlineCache = fetchYarnDeps {
    inherit (finalAttrs) src;
    hash = "sha256-Ck6Ba/qDlEW5jqKUX8tyB0QbiVXU8+ND2tvhftmYktY=";
  };

  preBuild = ''
    # install proper version info
    echo "${finalAttrs.version}-nix" > version.txt

    # makes network requests
    sed -i 's/corepack //g' package.json
  '';

  postBuild = ''
    yarn --offline run copy-assets
  '';

  postInstall = ''
    # Re-install only production dependencies
    yarn install --frozen-lockfile --force --production --offline --non-interactive \
      --ignore-engines --ignore-platform --ignore-scripts --no-progress

    # Replace matrix-sdk-crypto-nodejs with nixpkgs version
    nodeCryptoPath="node_modules/@matrix-org/matrix-sdk-crypto-nodejs"
    rm -rf "$nodeCryptoPath"
    cp -r ${matrix-sdk-crypto-nodejs}/lib/node_modules/@matrix-org/matrix-sdk-crypto-nodejs \
      "$nodeCryptoPath"
    chmod -R a+rwx "$nodeCryptoPath"

    # build better-sqlite3
    betterSqlitePath="node_modules/better-sqlite3"
    pushd "$betterSqlitePath"
    npm run build-release --offline --nodedir="${nodeSources}"
    rm -rf build/Release/{.deps,obj,obj.target,test_extension.node}
    find build -type f -exec \
          ${lib.getExe removeReferencesTo} -t "${nodeSources}" {} \;
    popd


    mkdir -p $out/lib/node_modules/draupnir
    mkdir $out/bin
    # Install outputs
    mv ./lib ./version.txt ./node_modules ./package.json $out/lib/node_modules/draupnir

    # Create wrapper executable
    makeWrapper ${lib.getExe nodejs_22} $out/bin/draupnir \
      --add-flags "--enable-source-maps" \
      --add-flags "$out/lib/node_modules/draupnir/lib/index.js"

  '';

  passthru = {
    tests = { inherit (nixosTests) draupnir; };
    updateScript = nix-update-script { };
  };

  meta = {
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
    license = lib.licenses.afl3;
    maintainers = with lib.maintainers; [ RorySys ];
    mainProgram = "draupnir";
  };
})
