{
  lib,
  fetchFromGitHub,
  makeBinaryWrapper,
  nodejs_24,
  matrix-sdk-crypto-nodejs,
  python3,
  sqlite,
  srcOnly,
  removeReferencesTo,
  buildNpmPackage,
  stdenv,
  cctools,
  nixosTests,
  nix-update-script,
}:
let
  nodeSources = srcOnly nodejs_24;
in

buildNpmPackage (finalAttrs: {
  pname = "draupnir";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "the-draupnir-project";
    repo = "Draupnir";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e6d9z5dkJg4ZpkN+yJFr8J8RWl9tcAhEYTOM+9413Ok=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    sqlite
    python3
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin cctools.libtool;

  npmDepsHash = "sha256-DvQM9Kr9Hc7/1OEZadZ1GvpAjfRmbdIcA6UDuFBQ+vo=";

  preBuild = ''
    # install proper version and branch info
    echo "${finalAttrs.version}-nix" > apps/draupnir/version.txt
    echo "main" > apps/draupnir/branch.txt

    # we already set the version and branch above
    sed -i "/build:assets/d" apps/draupnir/package.json
  '';

  postInstall = ''
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
    mv ./node_modules ./packages ./apps/draupnir/dist ./apps/draupnir/version.txt ./apps/draupnir/package.json $out/lib/node_modules/draupnir
    # Fix dangling symlink pointing to relative path ../apps/draupnir
    rm $out/lib/node_modules/draupnir/node_modules/draupnir

    # Create wrapper executable
    makeWrapper ${lib.getExe nodejs_24} $out/bin/draupnir \
      --add-flags "--enable-source-maps" \
      --add-flags "$out/lib/node_modules/draupnir/dist/index.js"

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
