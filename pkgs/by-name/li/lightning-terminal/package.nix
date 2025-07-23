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
  testers,
  curl,
  lightning-terminal,
}:

buildGoModule rec {
  pname = "lightning-terminal";
  version = "0.14.1-alpha";
  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "lightning-terminal";
    tag = "v${version}";
    hash = "sha256-sv/NsjAAF0vwD2xjRuGwHwV0L1gjCFQEw0SVp14Zyz0=";
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

  vendorHash = "sha256-Gbx4uz6q9Ef4QNv6DpIoCACjhT66iZ7GPNpd/g9MgKQ=";

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

  passthru.tests.litd-app = testers.runCommand {
    name = "test-litd-app";
    nativeBuildInputs = [
      curl
      lightning-terminal
    ];
    script = ''
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
  };

  lightning-app = stdenv.mkDerivation {
    pname = "lightning-app";
    src = "${src}/app";
    version = "0.0.1";
    yarnOfflineCache = fetchYarnDeps {
      yarnLock = "${src}/app/yarn.lock";
      hash = "sha256-ulOgKQRLG4cRi1N1DajmbZ0L7d08g5cYDA9itXu+Esw=";
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
