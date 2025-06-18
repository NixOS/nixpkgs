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
  version = "13.2.3";
  yarn-berry = yarn-berry_4;
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "acacode";
    repo = "swagger-typescript-api";
    rev = version;
    hash = "sha256-6sAp6RD3zplZL5FXharrlYXld/0Cb3EIPEf/T2+BEeE=";
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
    hash = "sha256-qW+1EyLfjTcXiMpDmcsHB6Mb2o0fTuMSX2U6G0T7viQ=";
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
