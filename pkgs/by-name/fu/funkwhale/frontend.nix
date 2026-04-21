{
  lib,
  stdenv,
  yarn-berry_4,
  nodejs,
  cypress,
  dart-sass,
  funkwhale,
}:
let
  yarn-berry = yarn-berry_4;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "funkwhale-frontend";
  inherit (funkwhale) version src;
  sourceRoot = "${finalAttrs.src.name}/front";

  strictDeps = true;
  __structuredAttrs = true;

  patches = [
    # yarn 4.14 update breaks this https://github.com/NixOS/nixpkgs/pull/513745
    # Remove patches after upstream updates to Yarn 4.14
    # see `packageManager` field in package.json
    # https://dev.funkwhale.audio/funkwhale/funkwhale/-/blob/develop/front/package.json?ref_type=heads#L139
    ./yarn-4.14-support.patch

    # when singing up the ui errors with a length not found in the console
    ./signup-bug.patch
  ];

  # TODO update script
  # yarn-berry-fetcher missing-hashes $(nix-build -A funkwhale.frontend.src)/front/yarn.lock >pkgs/by-name/fu/funkwhale/missing-hashes.json
  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src patches sourceRoot;
    missingHashes = ./missing-hashes.json;
    hash = "sha256-qY0yJk6IY8srLNJWSj4eBTuGoVFOBX8cc1QLODP8qMA=";
  };

  env = {
    CYPRESS_INSTALL_BINARY = 0;
    CYPRESS_RUN_BINARY = lib.getExe cypress;
  };

  nativeBuildInputs = [
    yarn-berry.yarnBerryConfigHook
    yarn-berry
    nodejs
    dart-sass
  ];

  buildPhase = ''
    runHook preBuild

    # force sass-embedded to use our own sass instead of the bundled one
    substituteInPlace node_modules/sass-embedded/dist/lib/src/compiler-path.js \
        --replace-fail 'compilerCommand = (() => {' 'compilerCommand = (() => { return ["${lib.getExe dart-sass}"];'

    yarn run build:deployment
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    cp -r dist $out
    runHook postInstall
  '';

  meta = funkwhale.meta // {
    description = "Frontend for the federated audio platform, Funkwhale";
  };
})
