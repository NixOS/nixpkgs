{
  lib,
  stdenv,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  cacert,
  gitMinimal,
  nodejs_20,
  python3,
  yarn,
  nixosTests,
  nix-update-script,
}:
let
  version = "25.5.0";
  src = fetchFromGitHub {
    name = "actualbudget-actual-source";
    owner = "actualbudget";
    repo = "actual";
    tag = "v${version}";
    hash = "sha256-NYAO1Yx3u0wm9F6zSwIolQkXBfFO1YkSKV5UMCBi8nw=";
  };
  translations = fetchFromGitHub {
    name = "actualbudget-translations-source";
    owner = "actualbudget";
    repo = "translations";
    # Note to updaters: this repo is not tagged, so just update this to the Git
    # tip at the time the update is performed.
    rev = "312fce7791e6722357e5d2f851407f4b7cf4ecb9";
    hash = "sha256-kDArpSFiNJJF5ZGCtcn7Ci7wCpI1cTSknDZ4sQgy/Nc=";
  };

  yarn_20 = yarn.override { nodejs = nodejs_20; };

  SUPPORTED_ARCHITECTURES = builtins.toJSON {
    os = [
      "darwin"
      "linux"
    ];
    cpu = [
      "arm"
      "arm64"
      "ia32"
      "x64"
    ];
    libc = [
      "glibc"
      "musl"
    ];
  };

  # We cannot use fetchYarnDeps because that doesn't support yarn2/berry
  # lockfiles (see https://github.com/NixOS/nixpkgs/issues/254369)
  offlineCache = stdenvNoCC.mkDerivation {
    name = "actual-server-${version}-offline-cache";
    inherit src;

    nativeBuildInputs = [
      cacert # needed for git
      gitMinimal # needed to download git dependencies
      yarn_20
    ];

    inherit SUPPORTED_ARCHITECTURES;

    buildPhase = ''
      runHook preBuild

      export HOME=$(mktemp -d)
      yarn config set enableTelemetry 0
      yarn config set cacheFolder $out
      # At this stage we don't need binaries yet, so we can skip preinstall
      # scripts here.
      yarn config set enableScripts false
      yarn config set --json supportedArchitectures "$SUPPORTED_ARCHITECTURES"

      # Install dependencies for all workspaces, and include devDependencies,
      # to build web UI. Dependencies will be re-created in offline mode in the
      # package's install phase.
      yarn install --immutable

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r ./node_modules $out/node_modules

      runHook postInstall
    '';
    dontFixup = true;

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-NPyFzklzAUIrTADTF/JBOieWMXOhL+X3pF3qXrfdyCs=";
  };

  webUi = stdenvNoCC.mkDerivation {
    pname = "actual-server-webui";
    inherit version;
    srcs = [
      src
      translations
    ];
    sourceRoot = "${src.name}/";

    nativeBuildInputs = [
      nodejs_20
      yarn_20
    ];

    inherit SUPPORTED_ARCHITECTURES;

    postPatch = ''
      ln -sv ../../../${translations.name} ./packages/desktop-client/locale
      cp -r ${offlineCache}/node_modules ./node_modules

      patchShebangs --build ./bin ./packages/*/bin

      # Patch all references to `git` to a no-op `true`. This neuter automatic
      # translation update.
      substituteInPlace bin/package-browser \
        --replace-fail "git" "true"

      # Allow `remove-untranslated-languages` to do its job.
      chmod -R u+w ./packages/desktop-client/locale
    '';

    buildPhase = ''
      runHook preBuild

      export HOME=$(mktemp -d)
      yarn config set enableTelemetry 0
      yarn config set cacheFolder ${offlineCache}
      yarn config set --json supportedArchitectures "$SUPPORTED_ARCHITECTURES"

      yarn build:server

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      cp -r packages/desktop-client/build $out

      runHook postInstall
    '';
    dontFixup = true;
  };
in
stdenv.mkDerivation {
  pname = "actual-server";
  inherit version src;

  nativeBuildInputs = [
    makeWrapper
    (python3.withPackages (ps: [ ps.setuptools ])) # Used by node-gyp
    yarn_20
  ];

  inherit SUPPORTED_ARCHITECTURES;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib,lib/actual/packages/sync-server,lib/actual/packages/desktop-client}
    cp -r ./packages/sync-server/{app.js,src,migrations,package.json,bin} $out/lib/actual/packages/sync-server
    # sync-server uses package.json to determine path to web ui.
    cp ./packages/desktop-client/package.json $out/lib/actual/packages/desktop-client
    cp -r ${webUi} $out/lib/actual/packages/desktop-client/build

    # Re-create node_modules/ to contain just production packages required for
    # sync-server itself, using existing offline cache. This will also now build
    # binaries.
    export HOME=$(mktemp -d)
    yarn config set enableNetwork false
    yarn config set enableOfflineMode true
    yarn config set enableTelemetry 0
    yarn config set cacheFolder ${offlineCache}
    yarn config set --json supportedArchitectures "$SUPPORTED_ARCHITECTURES"

    export npm_config_nodedir=${nodejs_20}

    yarn workspaces focus @actual-app/sync-server --production
    cp -r ./node_modules $out/lib/actual/

    makeWrapper ${lib.getExe nodejs_20} "$out/bin/actual-server" \
      --add-flags "$out/lib/actual/packages/sync-server/bin/actual-server.js" \
      --set NODE_PATH "$out/actual/lib/node_modules"

    runHook postInstall
  '';

  passthru = {
    inherit offlineCache webUi;
    tests = nixosTests.actual;
    passthru.updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://actualbudget.org/docs/releases";
    description = "Super fast privacy-focused app for managing your finances";
    homepage = "https://actualbudget.org/";
    mainProgram = "actual-server";
    license = lib.licenses.mit;
    # https://github.com/NixOS/nixpkgs/issues/403846
    broken = stdenv.isDarwin;
    maintainers = [
      lib.maintainers.oddlama
      lib.maintainers.patrickdag
    ];
  };
}
