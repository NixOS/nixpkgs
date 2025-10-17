{
  lib,
  fetchFromGitHub,
  makeWrapper,
  nodejs,
  matrix-sdk-crypto-nodejs,
  python3,
  sqlite,
  srcOnly,
  removeReferencesTo,
  mkYarnPackage,
  fetchYarnDeps,
  stdenv,
  cctools,
  nixosTests,
}:

# docs: https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/javascript.section.md#yarn2nix-javascript-yarn2nix
let
  hashesFile = builtins.fromJSON (builtins.readFile ./hashes.json);
  nodeSources = srcOnly nodejs;
in
mkYarnPackage rec {
  pname = "draupnir";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "the-draupnir-project";
    repo = "Draupnir";
    tag = "v${version}";
    hash = "sha256-ZzwZg7sevX0qKnlZ4snCcwSejWqA6JHCx3e6vWucO8U=";
  };

  nativeBuildInputs = [
    makeWrapper
    sqlite
  ];

  offlineCache = fetchYarnDeps {
    name = "${pname}-yarn-offline-cache";
    yarnLock = src + "/yarn.lock";
    hash = hashesFile.yarn_offline_cache_hash;
  };

  packageJSON = ./package.json;

  pkgConfig = {
    "@matrix-org/matrix-sdk-crypto-nodejs" = {
      postInstall = ''
        # replace with the existing package in nixpkgs
        cd ..
        rm -r matrix-sdk-crypto-nodejs
        ln -s ${matrix-sdk-crypto-nodejs}/lib/node_modules/@matrix-org/* ./
      '';
    };

    better-sqlite3 = {
      nativeBuildInputs = [ python3 ] ++ lib.optional stdenv.hostPlatform.isDarwin cctools.libtool;
      postInstall = ''
        # build native sqlite bindings
        npm run build-release --offline --nodedir="${nodeSources}"
        find build -type f -exec \
          ${lib.getExe removeReferencesTo} -t "${nodeSources}" {} \;
      '';
    };
  };

  preBuild = ''
    # install proper version info
    mkdir --parents deps/draupnir/
    echo "${version}-nix" > deps/draupnir/version.txt

    # makes network requests
    sed -i 's/corepack //g' deps/draupnir/package.json
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline --verbose build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir --parents $out/share
    cp --archive . $out/share/draupnir

    makeWrapper ${lib.getExe nodejs} $out/bin/draupnir \
      --add-flags $out/share/draupnir/deps/draupnir/lib/index.js

    runHook postInstall
  '';

  distPhase = "true";

  passthru = {
    tests = { inherit (nixosTests) draupnir; };
    updateScript = ./update.sh;
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
