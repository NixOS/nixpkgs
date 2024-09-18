{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  pkg-config,
  sqlite,
  fetchpatch,
  matrix-sdk-crypto-nodejs,
}:

buildNpmPackage rec {
  pname = "draupnir";
  version = "2.0.0-beta.6";

  src = fetchFromGitHub {
    owner = "the-draupnir-project";
    repo = "Draupnir";
    rev = "refs/tags/v${version}";
    hash = "sha256-s1LWXVwY+7LD7cJtZW7mBLsdpB499zS/nDsJ7qaQDfg=";
  };

  patches = [ ./remove-yarn.patch ];

  postPatch = ''
    rm yarn.lock
    cp ${./package-lock.json} ./package-lock.json

    # so that npmInstallHook picks it up
    substituteInPlace package.json --replace-fail '"main": "' '"bin": "'
  '';

  npmDepsHash = "sha256-zKfLnxXo383Fjb+xJWoRyFaMrpftYaFhyqPBe6pQ5Ek=";

  npmFlags = [ "--legacy-peer-deps" ];
  npmRebuildFlags = [ "--build-from-source" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ sqlite ];

  # TODO: move to preNpmRebuild
  preBuild = ''
    rm -r node_modules/better-sqlite3/{build,deps/common.gypi,deps/sqlite3.gyp,deps/sqlite3}

    patch -d node_modules/better-sqlite3 -p1 < ${./better-sqlite3-dynamic-link.patch}

    # TODO: add to nodejs patchset
    # sed -i "/undefined dynamic_lookup/d" node_modules/node-gyp/addon.gypi

    npm rebuild --verbose --build-from-source better-sqlite3
  '';

  postInstall =
    let
      root = "$out/lib/node_modules/draupnir";
    in
    ''
      # replace matrix-sdk-crypto-nodejs with nixos package
      rm -rv ${root}/node_modules/@matrix-org/matrix-sdk-crypto-nodejs
      ln -sv ${matrix-sdk-crypto-nodejs}/lib/node_modules/@matrix-org/matrix-sdk-crypto-nodejs ${root}/node_modules/@matrix-org/

      # add version file
      echo ${version} > ${root}/version.txt
    '';

  meta = with lib; {
    description = "A moderation tool for Matrix";
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
    maintainers = with maintainers; [ winter ];
  };
}
