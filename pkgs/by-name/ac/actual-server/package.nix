{
  lib,
  stdenv,
  cctools,
  fetchFromGitHub,
  git,
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
  version = "26.6.0";
  src = fetchFromGitHub {
    name = "actualbudget-actual-source";
    owner = "actualbudget";
    repo = "actual";
    tag = "v${version}";
    hash = "sha256-Ulz3M5z78mJQRr+te7qwVCeULCgEfE17NECSBagbI88=";
  };
  translations = fetchFromGitHub {
    name = "actualbudget-translations-source";
    owner = "actualbudget";
    repo = "translations";
    # Note to updaters: this repo is not tagged, so just update this to the Git
    # tip at the time the update is performed.
    rev = "c26df422b50745085191721b1f078664daac947d";
    hash = "sha256-u3EVA8J0VCLPafidGHhDiySB2fQdibntN+6FfErQi70=";
  };

in
stdenv.mkDerivation (finalAttrs: {
  srcs = [
    src
    translations
  ];
  sourceRoot = "${src.name}/";

  patches = [
    # Remove after upstream updates to Yarn 4.14
    # https://github.com/actualbudget/actual/blob/master/package.json#L123
    ./yarn-4.14-support.patch
  ];

  nativeBuildInputs = [
    yarn-berry
    nodejs
    (yarn-berry.yarnBerryConfigHook.override { inherit nodejs; })
    (python3.withPackages (ps: [ ps.setuptools ])) # Used by node-gyp
    makeBinaryWrapper
    # lage (used by `bin/package-browser`) shells out to `git ls-tree` to
    # compute file hashes for its build cache.
    git
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
  # during build, vite tries to access localhost
  __darwinAllowLocalNetworking = true;

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

    # lage hashes source files via `git ls-tree HEAD`, so it needs a repo with
    # at least one commit.
    git -c init.defaultBranch=main init -q
    git add -A
    git -c user.email=nix@localhost -c user.name=nix commit -q --allow-empty -m "snapshot"

    yarn build:server
    yarn workspace @actual-app/sync-server build

    runHook postBuild
  '';

  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes patches;
    hash = "sha256-lC9+B9agqwVARfMhXSTjb6cBj23PQz+RpZZ700jypF4=";
  };

  pname = "actual-server";
  inherit version src;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib,lib/actual/packages/sync-server,lib/actual/packages/desktop-client}
    cp -r ./packages/sync-server/build/. $out/lib/actual/packages/sync-server/
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
    cp -r ./packages/crdt $out/lib/actual/packages/crdt

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
