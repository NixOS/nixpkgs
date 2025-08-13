{
  lib,
  fetchFromGitHub,
  yarn-berry_4,
  stdenv,
  nodejs,
  makeWrapper,
}:
let
  pname = "swagger-typescript-api";
  version = "13.2.7";
  yarn-berry = yarn-berry_4;
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "acacode";
    repo = "swagger-typescript-api";
    rev = version;
    hash = "sha256-sK1zqpxQLnO5/6Spw/fgFcwotwb7vHX/aQUCW601HBQ=";
  };

  nativeBuildInputs = [
    makeWrapper
    yarn-berry.yarnBerryConfigHook
    yarn-berry
    nodejs
  ];

  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-KyE+Wmbx8hN9ewOyNk5imlrae7kqZgOYoyCg+K/dC+k=";
  };

  buildPhase = ''
    runHook preBuild

    yarn run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -r {dist,templates,node_modules} $out/lib

    makeWrapper ${nodejs}/bin/node $out/bin/${pname} \
      --add-flags $out/lib/dist/cli.js \
      --set NODE_ENV production \
      --set NODE_PATH "$out/lib/node_modules"

    runHook postInstall
  '';

  meta = {
    mainProgram = "swagger-typescript-api";
    description = "Generate TypeScript API client and definitions for fetch or axios from an OpenAPI specification";
    homepage = "https://github.com/acacode/swagger-typescript-api";
    changelog = "https://github.com/acacode/swagger-typescript-api/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ angelodlfrtr ];
  };
})
