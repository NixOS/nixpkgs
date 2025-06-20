{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  nodejs_22,
  python3,
  yarn-berry_4,
  nixosTests,
}:
let
  yarn-berry = yarn-berry_4;
  version = "25.6.1";
  src = fetchFromGitHub {
    name = "actualbudget-actual-source";
    owner = "actualbudget";
    repo = "actual";
    tag = "v${version}";
    hash = "sha256-+6rMfFmqm7HLYMgmiG+DE2bH5WkIZxwTiy2L/CdZYEI=";
  };
  translations = fetchFromGitHub {
    name = "actualbudget-translations-source";
    owner = "actualbudget";
    repo = "translations";
    # Note to updaters: this repo is not tagged, so just update this to the Git
    # tip at the time the update is performed.
    rev = "207279d37dbefd555e1470cd1c5a840c469ca672";
    hash = "sha256-oojADl5LaeO44+j4j/MpCs4c0Td4RwrBtqNB6ZEcELo=";
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
    nodejs_22
    yarn-berry.yarnBerryConfigHook
    (python3.withPackages (ps: [ ps.setuptools ])) # Used by node-gyp
    makeWrapper
  ];
  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    NODE_JQ_SKIP_INSTALL_BINARY = "true";
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
    hash = "sha256-mL4rIBJsx0wSAy1hY9fC0DyGLZOnvXhkFTlxQfK0Dfc=";
  };

  pname = "actual-server";
  inherit version src;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib,lib/actual/packages/sync-server,lib/actual/packages/desktop-client}
    cp -r ./packages/sync-server/build/{app.js,src,migrations,bin} $out/lib/actual/packages/sync-server
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

    makeWrapper ${lib.getExe nodejs_22} "$out/bin/actual-server" \
      --add-flags "$out/lib/actual/packages/sync-server/bin/actual-server.js" \
      --set NODE_PATH "$out/actual/lib/node_modules"

    runHook postInstall
  '';

  passthru = {
    inherit (finalAttrs) offlineCache;
    tests = nixosTests.actual;
  };

  meta = {
    changelog = "https://actualbudget.org/docs/releases";
    description = "Super fast privacy-focused app for managing your finances";
    homepage = "https://actualbudget.org/";
    mainProgram = "actual-server";
    license = lib.licenses.mit;
    # https://github.com/NixOS/nixpkgs/issues/403846
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = [
      lib.maintainers.oddlama
      lib.maintainers.patrickdag
    ];
  };
})
