{
  lib,
  stdenv,
  fetchFromGitHub,
  unzip,
  makeWrapper,
  # Notice: graphs will not sync without matching upstream's major electron version
  #         the specific electron version is set at top-level file to preserve override interface.
  #         whenever updating this package also sync electron version at top-level file.
  electron,
  autoPatchelfHook,
  git,
  nix-update-script,
  fetchYarnDeps,
  nodejs_18,
  yarn,
  jdk,
  clojure,
  fixup-yarn-lock,
  node-pre-gyp,
  python3,
  nodePackages,
}: let
  cljs-time = fetchFromGitHub {
    repo = "cljs-time";
    owner = "logseq";
    rev = "5704fbf48d3478eedcf24d458c8964b3c2fd59a9";
    hash = "sha256-IApL+SEm7AhbTN7J/1KiAKTx7rd53hchRh3jmPQ412g=";
  };
in
  stdenv.mkDerivation rec {
    pname = "logseq";
    version = "0.10.9";
    src = fetchFromGitHub {
      repo = pname;
      owner = pname;
      rev = version;
      hash = "sha256-2DrxXC/GT0ZwbX9DQwG9e6h4urkMH2OCaLCEiQuo0PA=";
    };

    nativeBuildInputs = [
      nodejs_18
      yarn
      # jdk
      clojure
      nodePackages.parcel
      nodePackages.node-gyp-build
      git
    ];
    buildInputs = [
      fixup-yarn-lock
      node-pre-gyp
      python3
    ];

    env = {
      "ELECTRON_SKIP_BINARY_DOWNLOAD" = "1";
      "PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD" = "1";
      "PARCEL_WORKER_BACKEND" = "process";
    };

    yarnOfflineCache = fetchYarnDeps {
      yarnLock = src + "/yarn.lock";
      hash = "sha256-HHGkmiZCAtXiNeX+s+26E2WbcNH5rOSbPDYFmB6Q6xg=";
    };

    amplifyOfflineCache = fetchYarnDeps {
      yarnLock = src + "/packages/amplify/yarn.lock";
      hash = "sha256-IOhSwIf5goXCBDGHCqnsvWLf3EUPqq75xfQg55snIp4=";
    };

    tldrawOfflineCache = fetchYarnDeps {
      yarnLock = src + "/tldraw/yarn.lock";
      hash = "sha256-CtMl3MPlyO5nWfFhCC1SLb/+1HUM3YfFATAPqJg3rUo=";
    };

    patches = [
      ./dist-amplify.patch
    ];

    configurePhase = ''
      runHook preConfigure

      export HOME=$(mktemp -d)

      yarn config --offline set yarn-offline-mirror "$tldrawOfflineCache"
      fixup-yarn-lock tldraw/yarn.lock
      yarn --offline --cwd tldraw/ install  --frozen-lockfile --offline --no-progress --non-interactive --ignore-scripts

      yarn config --offline set yarn-offline-mirror "$yarnOfflineCache"
      fixup-yarn-lock yarn.lock
      yarn install --frozen-lockfile --offline --no-progress --non-interactive --ignore-scripts --ignore-optional


      yarn config --offline set yarn-offline-mirror "$amplifyOfflineCache"
      fixup-yarn-lock packages/amplify/yarn.lock
      yarn --offline --cwd packages/amplify/ install --frozen-lockfile --offline --no-progress --non-interactive --ignore-optional --ignore-scripts --dist-dir dist

      patchShebangs node_modules/
      patchShebangs tldraw/node_modules/
      patchShebangs packages/amplify/node_modules/

      runHook postConfigure
    '';

    buildPhase = ''

      yarn config --offline set yarn-offline-mirror "$yarnOfflineCache" --ignore-optional
      # yarn config --offline set yarn-offline-mirror "$amplifyOfflineCache"
      yarn --offline release
    '';

    meta = {
      description = "Local-first, non-linear, outliner notebook for organizing and sharing your personal knowledge base";
      homepage = "https://github.com/logseq/logseq";
      changelog = "https://github.com/logseq/logseq/releases/tag/${version}";
      license = lib.licenses.agpl3Plus;
      maintainers = [];
      platforms = ["x86_64-linux"] ++ lib.platforms.darwin;
      mainProgram = "logseq";
    };
  }
