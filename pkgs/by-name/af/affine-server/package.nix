{
  cargo,
  fetchFromGitHub,
  lib,
  makeBinaryWrapper,
  nodejs_24,
  pkg-config,
  rustPlatform,
  stdenv,
  yarn,
  prisma-engines_6,
  rustc,
  opus,
  jq,
  pkgs,
}:
let
  nodejs = nodejs_24;

  prismaEngines = prisma-engines_6.overrideAttrs (
    finalAttrs: _: {
      version = "6.8.2";

      src = fetchFromGitHub {
        owner = "prisma";
        repo = "prisma-engines";
        tag = finalAttrs.version;
        hash = "sha256-YvP3yJQoe+q7jjpwntaYkYjxyoDzqnXcpIZa4Y+I/+E=";
      };

      cargoDeps = rustPlatform.fetchCargoVendor {
        inherit (finalAttrs) pname version src;
        hash = "sha256-5iJM0mqBfY3KdtToxCas4Xxu5jCf+CNwAUA2zuGu+iM=";
      };
    }
  );

  mYarn = pkgs.yarn-berry_4.overrideAttrs (_: {
    version = "4.18.0";
    src = pkgs.fetchFromGitHub {
      owner = "yarnpkg";
      repo = "berry";
      tag = "@yarnpkg/cli/4.18.0";
      hash = "sha256-pO89wh17cW9/RGKjo70yiefr+9nlJAQs4ZEdUnzdgQM=";
    };
  });

  targetArch =
    if stdenv.hostPlatform.isx86_64 then
      "amd64"
    else if stdenv.hostPlatform.isAarch64 then
      "arm64"
    else if stdenv.hostPlatform.isArm then
      "armv7"
    else
      throw "Unsupported architecture";

in
stdenv.mkDerivation (finalAttrs: {
  pname = "affine-server";
  version = "v0.27.4";
  BUILD_TYPE = "stable";

  strictDeps = true;
  __structuredAttrs = true;

  GITHUB_SHA = finalAttrs.src.rev;

  src = fetchFromGitHub {
    owner = "toeverything";
    repo = "affine";
    tag = "${finalAttrs.version}";
    hash = "sha256-MuzQkiiMUrmFVzHCA5l5hzXm7wA7ChPaKzcrJtc1R3Y=";
  };

  patches = [
    ./patches/generate-graphql-schema-in-memory.patch
  ];

  missingHashes = ./missing-hashes.json;

  offlineCache = mYarn.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-qOsLgyEluCX0ivMGSfIf8OZf/oA/LiFvmNe80JG7FW8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-fQY4DmkbZQljXQzWRNLzaYxdPoenWTbOtjBvqT/HFYE=";
  };

  nativeBuildInputs = [
    cargo
    rustc
    mYarn.yarnBerryConfigHook
    mYarn
    jq
    makeBinaryWrapper
    nodejs
    pkg-config
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    opus
  ];

  configurePhase = ''
    runHook preConfigure

    export ELECTRON_SKIP_BINARY_DOWNLOAD=1

    export PRISMA_QUERY_ENGINE_LIBRARY=${prismaEngines}/lib/libquery_engine.node
    export PRISMA_SCHEMA_ENGINE_BINARY=${prismaEngines}/bin/schema-engine

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    bash ./scripts/set-version.sh ${finalAttrs.version}

    ${lib.getExe mYarn} affine @affine/server-native build

    cp ./packages/backend/native/server-native.node ./packages/backend/native/server-native.arm64.node
    cp ./packages/backend/native/server-native.node ./packages/backend/native/server-native.armv7.node
    cp ./packages/backend/native/server-native.node ./packages/backend/native/server-native.x64.node


    ${lib.getExe mYarn} workspace @affine/server build

    ${lib.getExe mYarn} affine @affine/web build
    ${lib.getExe mYarn} affine @affine/admin build
    ${lib.getExe mYarn} affine @affine/mobile build

    ${lib.getExe mYarn} workspaces focus @affine/server --production

    ${lib.getExe mYarn} workspace @affine/server prisma generate


    AFFINE_DOCKER_CLEAN=1 TARGETARCH="${targetArch}" node ./packages/backend/server/scripts/docker-clean.mjs

    rm -rf ./node_modules/@affine

    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck

    ${lib.getExe mYarn} workspace @affine/server test

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    cp -r ./packages/backend/server $out
    cp -r ./node_modules $out/

    cp -r ./packages/frontend/apps/web/dist $out/static
    cp -r ./packages/frontend/admin/dist $out/static/admin
    cp -r ./packages/frontend/apps/mobile/dist $out/static/mobile

    mkdir -p $out/bin

    makeBinaryWrapper ${nodejs}/bin/node $out/bin/affine-server-predeploy \
      --chdir "$out" \
      --add-flags "./scripts/self-host-predeploy.js" \
      --set-default NODE_ENV production \
      --set-default PRISMA_QUERY_ENGINE_LIBRARY ${prismaEngines}/lib/libquery_engine.node \
      --set-default PRISMA_SCHEMA_ENGINE_BINARY ${prismaEngines}/bin/schema-engine \
      --set-default DEPLOYMENT_TYPE selfhosted \
      --prefix PATH : "${
        lib.makeBinPath [
          (yarn.override { inherit nodejs; })
        ]
      }"

    makeBinaryWrapper ${nodejs}/bin/node $out/bin/affine-server \
      --chdir "$out" \
      --add-flags "dist/main.js" \
      --set-default NODE_ENV production \
      --set-default PRISMA_QUERY_ENGINE_LIBRARY ${prismaEngines}/lib/libquery_engine.node \
      --set-default DEPLOYMENT_TYPE selfhosted

    runHook postInstall
  '';

  meta = {
    description = "A privacy-focused, local-first, open-source, and ready-to-use alternative for Notion & Miro.";
    homepage = "https://affine.pro";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vagahbond ];
  };
})
