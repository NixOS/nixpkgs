# https://nixos.org/manual/nixpkgs/stable/#javascript-yarn
{
  cargo,
  coreutils,
  fetchFromGitHub,
  gnugrep,
  lib,
  makeBinaryWrapper,
  nodejs_24,
  pkg-config,
  runCommand,
  rustPlatform,
  stdenv,
  yarn,
  prisma-engines_6,
  rustc,
  opus,
  jq,
  yarn-berry_4,
}:
let
  nodejs = nodejs_24;

  targetArch = if stdenv.hostPlatform.isx86_64 then "amd64" else "arm64";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "affine-server";
  version = "0.27.4";

  strictDeps = true;
  __structuredAttrs = true;

  env = {

    BUILD_TYPE = "stable";

    # Prevent invocation of `git` at frontend build time
    GITHUB_SHA = finalAttrs.src.tag;
  };

  src = fetchFromGitHub {
    owner = "toeverything";
    repo = "affine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MuzQkiiMUrmFVzHCA5l5hzXm7wA7ChPaKzcrJtc1R3Y=";
  };

  patches = [
    ./patches/generate-graphql-schema-in-memory.patch
  ];

  missingHashes = ./missing-hashes.json;

  offlineCache = yarn-berry_4.fetchYarnBerryDeps {
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
    yarn-berry_4.yarnBerryConfigHook
    yarn-berry_4
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

    export PRISMA_QUERY_ENGINE_LIBRARY=${prisma-engines_6}/lib/libquery_engine.node
    export PRISMA_SCHEMA_ENGINE_BINARY=${prisma-engines_6}/bin/schema-engine

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    bash ./scripts/set-version.sh ${finalAttrs.version}

    yarn affine @affine/server-native build

    cp ./packages/backend/native/server-native.node ./packages/backend/native/server-native.arm64.node
    cp ./packages/backend/native/server-native.node ./packages/backend/native/server-native.armv7.node
    cp ./packages/backend/native/server-native.node ./packages/backend/native/server-native.x64.node


    yarn workspace @affine/server build

    yarn affine @affine/web build
    yarn affine @affine/admin build
    yarn affine @affine/mobile build

    yarn workspaces focus @affine/server --production

    yarn workspace @affine/server prisma generate


    AFFINE_DOCKER_CLEAN=1 TARGETARCH="${targetArch}" node ./packages/backend/server/scripts/docker-clean.mjs

    rm -rf ./node_modules/@affine

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/bin
    cp -r ./packages/backend/server $out/lib/affine-server
    cp -r ./node_modules $out/lib/affine-server/
    cp -r ./packages/frontend/apps/web/dist $out/lib/affine-server/static
    cp -r ./packages/frontend/admin/dist $out/lib/affine-server/static/admin
    cp -r ./packages/frontend/apps/mobile/dist $out/lib/affine-server/static/mobile

    makeBinaryWrapper ${nodejs}/bin/node $out/bin/affine-server-predeploy \
      --chdir "$out/lib/affine-server" \
      --add-flags "./scripts/self-host-predeploy.js" \
      --set-default NODE_ENV production \
      --set-default PRISMA_QUERY_ENGINE_LIBRARY ${prisma-engines_6}/lib/libquery_engine.node \
      --set-default PRISMA_SCHEMA_ENGINE_BINARY ${prisma-engines_6}/bin/schema-engine \
      --set-default DEPLOYMENT_TYPE selfhosted \
      --prefix PATH : "${
        lib.makeBinPath [
          (yarn.override { inherit nodejs; })
        ]
      }"

    makeBinaryWrapper ${nodejs}/bin/node $out/bin/affine-server \
      --chdir "$out/lib/affine-server" \
      --add-flags "dist/main.js" \
      --set-default NODE_ENV production \
      --set-default PRISMA_QUERY_ENGINE_LIBRARY ${prisma-engines_6}/lib/libquery_engine.node \
      --set-default DEPLOYMENT_TYPE selfhosted

    runHook postInstall
  '';

  passthru.tests =
    let
      startupFailure =
        binary: expectedError:
        runCommand "${binary}-startup-test"
          {
            nativeBuildInputs = [
              coreutils
              gnugrep
            ];
          }
          ''
            mkdir -p "$TMPDIR/home"

            status=0
            env -i HOME="$TMPDIR/home" PATH="$PATH" \
              timeout --kill-after=5s 60s ${finalAttrs.finalPackage}/bin/${binary} \
              > startup.log 2>&1 || status=$?

            if [ "$status" -ne 1 ]; then
              cat startup.log
              echo "Expected ${binary} to exit with status 1, got $status"
              exit 1
            fi

            if ! grep -Fq ${lib.escapeShellArg expectedError} startup.log; then
              cat startup.log
              echo "Expected ${binary} to fail because its database is not configured or available"
              exit 1
            fi

            if grep -Eq 'ERR_MODULE_NOT_FOUND|MODULE_NOT_FOUND|ERR_DLOPEN_FAILED|Cannot find module|Cannot find package|command not found|dyld[[]|error while loading shared libraries' startup.log; then
              cat startup.log
              echo "Unexpected packaging error in ${binary}"
              exit 1
            fi

            mkdir -p "$out"
            cp startup.log "$out/"
          '';
    in
    {
      server-startup = startupFailure "affine-server" "BackendRuntime failed to connect postgres:";
      predeploy-startup = startupFailure "affine-server-predeploy" "Environment variable not found: DATABASE_URL.";
    };

  meta = {
    description = "Privacy-focused, local-first alternative to Notion and Miro (self-hosted server)";
    homepage = "https://affine.pro";
    changelog = "https://github.com/toeverything/AFFiNE/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      mit
      mpl20
    ];
    maintainers = with lib.maintainers; [ vagahbond ];
    mainProgram = "affine-server";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
