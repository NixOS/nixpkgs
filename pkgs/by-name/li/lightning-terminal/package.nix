{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  nodejs,
  yarn,
  yarnConfigHook,
  yarnBuildHook,
  fetchYarnDeps,
  go,
  versionCheckHook,
  runCommandWith,
  curl,
  lightning-terminal,
  _experimental-update-script-combinators,
  gitUpdater,
  nurl,
  nix,
  gitMinimal,
  writeShellScript,
}:

buildGoModule rec {
  pname = "lightning-terminal";
  version = "0.16.0-alpha";
  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "lightning-terminal";
    tag = "v${version}";
    hash = "sha256-lAWAyB6SAk23FS/smJyxl2yDayYLqzpNPI6bdPhRuK4=";
    leaveDotGit = true;
    # Populate values that require us to use git.
    postFetch = ''
      cd "$out"
      >$out/COMMIT git rev-parse HEAD
      >$out/LOOP_COMMIT sed -ne 's:^\s*github.com/lightninglabs/loop\s\(.*\):\1:p' go.mod
      >$out/POOL_COMMIT sed -ne 's:^\s*github.com/lightninglabs/pool\s\(.*\):\1:p' go.mod
      >$out/TAP_COMMIT sed -ne 's:^\s*github.com/lightninglabs/taproot-assets\s\(.*\):\1:p' go.mod
      find -name .git -print0 | xargs -0 rm -rf
    '';
  };

  vendorHash = "sha256-b7AjCKUtjGr1L0+dFnPupKPM/DDj6LlBQ2T25kxCwdk=";

  buildInputs = [ lightning-app ];
  postUnpack = ''
    echo "Copying app build output into app/build dir to embed into litd."
    cp -r ${lightning-app}/* source/app/build/

    echo "Asserting that app/build/index.html exists."
    if [ ! -f source/app/build/index.html ]; then
      echo "ERROR: app/build/index.html not found!"
      exit 1
    fi
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/lightningnetwork/lnd/build.GoVersion=${go.version}"
    "-X github.com/lightningnetwork/lnd/build.RawTags=${lib.concatStringsSep "," tags}"
    "-X github.com/lightninglabs/lightning-terminal.appFilesPrefix="
    "-X github.com/lightninglabs/lightning-terminal.Commit=${src.tag}"
  ];

  # ldflags based on metadata from git and source
  preBuild = ''
    ldflags+=" -X github.com/lightninglabs/loop.Commit=$(cat LOOP_COMMIT)"
    ldflags+=" -X github.com/lightninglabs/pool.Commit=$(cat POOL_COMMIT)"
    ldflags+=" -X github.com/lightninglabs/taproot-assets.Commit=$(cat TAP_COMMIT)"
    # Note that this is build.Commit, not Commit,
    # this may be why Makefile uses COMMIT and not LND_COMMIT here,
    # so let's do the same.
    ldflags+=" -X github.com/lightningnetwork/lnd/build.Commit=${src.tag}"
    ldflags+=" -X github.com/lightningnetwork/lnd/build.CommitHash=$(cat COMMIT)"
  '';

  subPackages = [
    "cmd/litcli"
    "cmd/litd"
  ];

  tags = [
    "litd"
    "autopilotrpc"
    "signrpc"
    "walletrpc"
    "chainrpc"
    "invoicesrpc"
    "watchtowerrpc"
    "neutrinorpc"
    "peersrpc"
  ];

  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/litcli";
  versionCheckProgramArg = "--version";
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru.tests.litd-app =
    runCommandWith
      {
        name = "test-litd-app";
        derivationArgs = {
          nativeBuildInputs = [
            curl
            lightning-terminal
          ];
        };
      }
      ''
        litd \
          --uipassword=12345678 \
          --insecure-httplisten=127.0.0.1:8080 \
          --httpslisten= &
        sleep 2
        GETindexHTTPCode=$(curl -o /dev/null -w "%{http_code}" -Lvs 127.0.0.1:8080/index.html)
        if [ "$GETindexHTTPCode" = 200 ]; then
          touch $out
        fi
      '';

  # Usage: nix-shell maintainers/scripts/update.nix --argstr package lightning-terminal --argstr commit true
  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (gitUpdater {
      rev-prefix = "v";
      ignoredVersions = ".*rc.*";
    })
    {
      command = [
        (writeShellScript "update-hashes.sh" ''
          set -euxo pipefail

          . ${stdenv}/setup
          PATH="${
            lib.makeBinPath [
              gitMinimal
              nix
              nurl
            ]
          }:$PATH"

          nixpkgs="$(git rev-parse --show-toplevel)"
          packageVersion=$(nix --extra-experimental-features nix-command eval --impure --raw -f "$nixpkgs" "$UPDATE_NIX_ATTR_PATH.version")
          if [ x"$UPDATE_NIX_OLD_VERSION" != x"$packageVersion" ]; then
            vendorHashOld=${lightning-terminal.vendorHash}
            vendorHashNew=$(nurl -e "(import $nixpkgs/. { }).$UPDATE_NIX_ATTR_PATH.goModules")
            yarnOfflineCacheHashOld=${lightning-app.yarnOfflineCache.outputHash}
            yarnOfflineCacheHashNew=$(nurl -e "let pkgs = (import $nixpkgs/. { }); in \
              pkgs.fetchYarnDeps \
                { yarnLock = pkgs.$UPDATE_NIX_ATTR_PATH.src + \"/app/yarn.lock\"; \
                  hash = pkgs.lib.fakeHash; \
                }")

            substituteInPlace \
              "$nixpkgs"/pkgs/by-name/li/lightning-terminal/package.nix \
              --replace-fail "$vendorHashOld" "$vendorHashNew" \
              --replace-fail "$yarnOfflineCacheHashOld" "$yarnOfflineCacheHashNew"
          fi
        '')
      ];
      supportedFeatures = [ "silent" ];
    }
  ];

  lightning-app = stdenv.mkDerivation {
    pname = "lightning-app";
    src = "${src}/app";
    version = "0.0.1";
    yarnOfflineCache = fetchYarnDeps {
      yarnLock = "${src}/app/yarn.lock";
      hash = "sha256-3oeuCsdm9HcMlKBBWsROY7SKN1vw8H/IXtvkTLrO07I=";
    };

    # Remove this command from package.json. It requires Git and it is not
    # really needed.
    postPatch = ''
      substituteInPlace package.json \
        --replace '"postbuild": "git restore build/.gitkeep",' ' '
    '';

    nativeBuildInputs = [
      nodejs
      yarn
      yarnConfigHook
      yarnBuildHook
    ];

    preBuild = ''
      # Disable linter. It finds a lot of proposed substitutions and fails.
      export DISABLE_ESLINT_PLUGIN=true
      export CI=false
    '';

    installPhase = ''
      mkdir -p $out
      cp -r build/* $out/
    '';
  };

  meta = {
    description = "All-in-one Lightning node management tool that includes LND, Loop, Pool, Faraday, and Tapd";
    homepage = "https://github.com/lightninglabs/lightning-terminal";
    license = lib.licenses.mit;
    changelog = "https://github.com/lightninglabs/lightning-terminal/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ HannahMR ];
    mainProgram = "litcli";
  };
}
