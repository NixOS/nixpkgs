{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_26,
  pkg-config,
  node-gyp,
  makeWrapper,
  vips,
  faketty,
  nixosTests,
  # --- Prisma build inputs ---
  openssl,
  rustPlatform,
  protobuf,
  stdenv,
  git,
}:

let
  # Scholarsome needs prisma v4.15.0, which is not available on nixpkgs.
  #
  # Adapted from :
  #   https://github.com/NixOS/nixpkgs/blob/29bcead8405cfe4c00085843eb372cc43837bb9d/pkgs/development/tools/database/prisma-engines/default.nix
  prisma-engines_4 = rustPlatform.buildRustPackage {
    pname = "prisma-engines";
    version = "4.15.0";

    src = fetchFromGitHub {
      owner = "prisma";
      repo = "prisma-engines";
      rev = "8fbc245156db7124f997f4cecdd8d1219e360944";
      hash = "sha256-9TSNO28e0kLFZ+/FnHT69VU6yzd4ATdmto7+u87YTHU=";
    };

    # Needed to bypass the `!#[deny(warnings)]` enforced by user-facing-errors v0.1.0,
    # otherwise the build will fail with :
    #   > error: use of deprecated type alias `std::panic::PanicInfo`: use `PanicHookInfo` instead
    env.RUSTFLAGS = "--cap-lints warn";

    # Use system openssl
    env.OPENSSL_NO_VENDOR = 1;

    nativeBuildInputs = [
      pkg-config
      git
    ];

    buildInputs = [
      openssl
      protobuf
    ];

    # Prevent IFD issues from `cargoLock.lockFile = "${src}/Cargo.lock"`
    cargoHash = "sha256-wzIINgpjHD7iLOPZsxYUNk2G1y8FxA5du4CJ2FtCrSs=";

    # We won't need `prisma-fmt` nor the `query-engine`.
    cargoBuildFlags = [
      "-p"
      "query-engine-node-api"
      "-p"
      "schema-engine-cli"
      # The above actually produces the migration engine, it was being renamed at the time.
      # See : https://github.com/prisma/prisma-engines/blob/8fbc245156db7124f997f4cecdd8d1219e360944/schema-engine/cli/Cargo.toml#L32-L35
    ];

    preBuild = ''
      export OPENSSL_DIR=${lib.getDev openssl}
      export OPENSSL_LIB_DIR=${lib.getLib openssl}/lib

      export PROTOC=${protobuf}/bin/protoc
      export PROTOC_INCLUDE="${protobuf}/include";

      export SQLITE_MAX_VARIABLE_NUMBER=250000
      export SQLITE_MAX_EXPR_DEPTH=10000
    '';

    postInstall = ''
      mv $out/lib/libquery_engine${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/libquery_engine.node
    '';

    doCheck = false;
  };
in
buildNpmPackage (finalAttrs: {
  pname = "scholarsome";
  version = "1.2.0-unstable-2024-07-24";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "hwgilbert16";
    repo = "scholarsome";
    rev = "d7fbe9b43c49685b37f3b1fb7d24bf30ff4be2a1";
    hash = "sha256-+7No2LV639Jd0SaFQphkqdSoDRrMNdEvu4hT2rdG1P4=";
  };

  # Let's jump straight to nodejs_26, shouldn't be EOS anytime soon.
  nodejs = nodejs_26;

  env.NODE_ENV = "production";

  # Need this for dependencies to resolve correctly.
  npmFlags = [ "--legacy-peer-deps" ];

  npmDepsHash = "sha256-2haXPbpD7RBkSYjPwTi6j+2PYXf27vMd4g4opt8E/BU=";

  patches = [
    ./0001-scripts-disable-husky.patch # husky fails to run during the install phase : `npm error sh: line 1: husky: command not found`
    ./0002-package-json-deps.patch # see comment above `postPatch`
    ./0003-api-spec-and-exit.patch # `api-spec.json` must exist at build time, yet is only generated at run time, see comment in the patch file
  ];

  # Had to regenerate the `package-lock.json` for multiple reasons.
  # See : https://github.com/NixOS/nixpkgs/pull/544112#issuecomment-5090453449
  postPatch = ''
    cp ${./package-lock-fixed.json} package-lock.json
  '';

  nativeBuildInputs = [
    makeWrapper
    pkg-config # needed for `sharp` to be able to discover `libvips`
    node-gyp # needed for nodejs library `sharp`
  ];

  buildInputs = [
    vips # needed for nodejs library `sharp`
  ];

  npmBuildScript = "build";

  preBuild = ''
    # Have to do this or else prisma tries to download its binaries :
    #   > Downloading Prisma engines for Node-API for debian-openssl-1.1.x [] 0%
    #   > Error: request to https://binaries.prisma.sh/...openssl-1.1.x/libquery_engine.so.node.gz.sha256 failed, reason: getaddrinfo EAI_AGAIN binaries.prisma.sh
    export PRISMA_MIGRATION_ENGINE_BINARY="${lib.getExe' prisma-engines_4 "migration-engine"}"
    export PRISMA_QUERY_ENGINE_LIBRARY="${lib.getLib prisma-engines_4}/lib/libquery_engine.node"

    # Prevents errors like `apps/front/src/app/auth/auth.service.ts - Module '"@prisma/client"' has no exported member 'User'`.
    ${lib.getExe' nodejs_26 "npx"} prisma generate
  '';

  # See explanation in ./0003-api-spec-and-exit.patch
  postBuild = ''
    echo "Generating api-spec.json..."

    GENERATE_API_SPEC_AND_EXIT=1 \
    JWT_SECRET=foo \
    STORAGE_TYPE=local node dist/apps/api/main.js

    echo "Rebuilding docs..."

    # Need faketty here or nx will complain
    # See : https://github.com/nrwl/nx/issues/22445
    CI=true ${lib.getExe faketty} ${lib.getExe' nodejs_26 "npx"} nx run docs:build
  '';

  postInstall = ''
    # `node_modules/` is correctly kept by buildNpmPackage, but `dist/` is left behind since it is listed in the gitignore.
    mkdir -p $out/lib/node_modules/scholarsome/dist
    cp -r dist/* $out/lib/node_modules/scholarsome/dist/

    # Remove a couple of unnecessary files and folders from the output
    rm -rf $out/lib/node_modules/scholarsome/{.github,.husky,.vscode,apps,libs,tools}
    find "$out/lib/node_modules/scholarsome" -maxdepth 1 -type f ! -name 'package.json' -delete

    # Prisma wants openssl to connect to the DB
    makeWrapper ${lib.getExe nodejs_26} "$out/bin/scholarsome" \
      --add-flags "$out/lib/node_modules/scholarsome/dist/apps/api/main.js" \
      --prefix PATH : ${lib.makeBinPath [ openssl ]} \
      --set NODE_ENV production \
      --set PRISMA_MIGRATION_ENGINE_BINARY "${lib.getExe' prisma-engines_4 "migration-engine"}" \
      --set PRISMA_QUERY_ENGINE_LIBRARY "${lib.getLib prisma-engines_4}/lib/libquery_engine.node"

    # Since the Scholarsome module needs to perform this task, we'll create a wrapper,
    # so that the module doesn't have to point to `prisma-engines_4` nor `nodejs_26`.
    # We have to add `nodejs_26` to the path explicitly because of `package.json` :
    #   > "migrate": "npx prisma migrate deploy"
    makeWrapper ${lib.getExe' nodejs_26 "npm"} "$out/bin/scholarsome-migrate" \
      --chdir "$out/lib/node_modules/scholarsome" \
      --add-flags "run" \
      --add-flags "migrate" \
      --prefix PATH : "${
        lib.makeBinPath [
          nodejs_26
          openssl
        ]
      }" \
      --set NODE_ENV production \
      --set PRISMA_MIGRATION_ENGINE_BINARY "${lib.getExe' prisma-engines_4 "migration-engine"}" \
      --set PRISMA_QUERY_ENGINE_LIBRARY "${lib.getLib prisma-engines_4}/lib/libquery_engine.node"
  '';

  passthru.tests = {
    scholarsome = nixosTests.scholarsome;
  };

  meta = {
    description = "Web-based interactive flashcard learning software";
    homepage = "https://github.com/hwgilbert16/scholarsome";
    license = lib.licenses.agpl3Only;
    mainProgram = "scholarsome";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ vitto4 ];
  };
})
