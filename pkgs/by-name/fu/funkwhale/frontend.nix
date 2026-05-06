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
  inherit (funkwhale) version src;
  yarn-berry = yarn-berry_4;
in
stdenv.mkDerivation {
  pname = "funkwhale-frontend";
  inherit version src;
  sourceRoot = "${src.name}/front";

  __structuredAttrs = true;

  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry.fetchYarnBerryDeps {
    yarnLock = "${src}/front/yarn.lock";
    # TODO update script
    # yarn-berry-fetcher missing-hashes $(nix-build -A funkwhale.frontend.src)/front/yarn.lock >pkgs/by-name/fu/funkwhale/missing-hashes.json
    missingHashes = ./missing-hashes.json;
    hash = "sha256-II/9X4JILGJli5gSznIfKMGlDzp84IMJS7l1qV2KNOk=";
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
}
