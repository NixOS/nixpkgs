{
  lib,
  stdenv,
  cctools,
  fetchFromGitHub,
  jq,
  makeBinaryWrapper,
  nodejs_22,
  python3,
  xcbuild,
  yarn-berry_4,
  nixosTests,
}:
let
  nodejs = nodejs_22;
  yarn-berry = yarn-berry_4.override { inherit nodejs; };
  version = "26.4.0";
  src = fetchFromGitHub {
    name = "actualbudget-actual-source";
    owner = "actualbudget";
    repo = "actual";
    tag = "v${version}";
    hash = "sha256-Gc2klYxGv+vd1Yc2ftj25B4Kea0GKkpjYcVDN9HvLPk=";
  };
  translations = fetchFromGitHub {
    name = "actualbudget-translations-source";
    owner = "actualbudget";
    repo = "translations";
    # Note to updaters: this repo is not tagged, so just update this to the Git
    # tip at the time the update is performed.
    rev = "14c3f5e7ed4e47dedab8cebeaf5e2170cfa5f9d0";
    hash = "sha256-+4hENE9unsta1YoIDE7shcjy1AlWfnPczvm4jYnw5Dw=";
  };

in
stdenv.mkDerivation (finalAttrs: {
  srcs = [
    src
    translations
  ];
  sourceRoot = "${src.name}/";

  nativeBuildInputs = [
    yarn-berry
    nodejs
    (yarn-berry.yarnBerryConfigHook.override { inherit nodejs; })
    (python3.withPackages (ps: [ ps.setuptools ])) # Used by node-gyp
    makeBinaryWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools
    xcbuild
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    NODE_JQ_SKIP_INSTALL_BINARY = "true";
    SHARP_IGNORE_GLOBAL_LIBVIPS = "1";
  };

  postPatch = ''
    ln -sv ../../../${translations.name} ./packages/desktop-client/locale

    patchShebangs --build ./bin ./packages/*/bin

    # Patch all references to `git` to a no-op `true`. This neuter automatic
    # translation update.
    substituteInPlace bin/package-browser \
      --replace-fail "git" "true"

    # Allow `remove-untranslated-languages` to do its job.
    chmod -R u+w ./packages/desktop-client/locale

    # Disable the postinstall script for `protoc-gen-js` because it tries to
    # use network in buildPhase. It's just used as a dev tool and the generated
    # protobuf code is committed in the repository.
    cat <<< $(${lib.getExe jq} '.dependenciesMeta."protoc-gen-js".built = false' ./package.json) > ./package.json

    # Disable building @swc/core from source - use the pre-built binaries instead
    cat <<< $(${lib.getExe jq} '.dependenciesMeta."@swc/core".built = false' ./package.json) > ./package.json

    # Disable the install script for sharp to prevent it from trying to download binaries
    cat <<< $(${lib.getExe jq} '.dependenciesMeta."sharp".built = false' ./package.json) > ./package.json
  '';

  buildPhase = ''
    runHook preBuild

    export HOME=$(mktemp -d)

    yarn build:server
    yarn workspace @actual-app/sync-server build

    runHook postBuild
  '';

  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-WWnf7HgTdyWrrHZA43hPjv8Q1PO1ETMKkd0eSu0pQ3M=";
  };

  pname = "actual-server";
  inherit version src;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib,lib/actual/packages/sync-server,lib/actual/packages/desktop-client}
    cp -r ./packages/sync-server/build/{app.js,src,migrations,bin} $out/lib/actual/packages/sync-server
    # sync-server uses package.json to determine version info
    cp ./packages/sync-server/package.json $out/lib/actual/packages/sync-server
    # sync-server uses package.json to determine path to web ui.
    cp ./packages/desktop-client/package.json $out/lib/actual/packages/desktop-client
    cp -r packages/desktop-client/build $out/lib/actual/packages/desktop-client/build

    # Re-create node_modules/ to contain just production packages required for
    # sync-server itself, using existing offline cache. This will also now build
    # binaries.
    export HOME=$(mktemp -d)

    yarn workspaces focus @actual-app/sync-server --production
    rm -r node_modules/.bin
    cp -r ./node_modules $out/lib/actual/

    makeBinaryWrapper ${lib.getExe nodejs} "$out/bin/actual-server" \
      --add-flags "$out/lib/actual/packages/sync-server/bin/actual-server.js" \
      --set NODE_PATH "$out/actual/lib/node_modules"

    runHook postInstall
  '';

  passthru = {
    inherit (finalAttrs) offlineCache;
    inherit translations;
    tests = nixosTests.actual;
    updateScript = ./update.sh;
  };

  meta = {
    changelog = "https://actualbudget.org/docs/releases";
    description = "Super fast privacy-focused app for managing your finances";
    homepage = "https://actualbudget.org/";
    mainProgram = "actual-server";
    license = lib.licenses.mit;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = [
      lib.maintainers.oddlama
      lib.maintainers.patrickdag
      lib.maintainers.yash-garg
    ];
  };
})
