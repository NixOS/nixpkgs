{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  callPackage,
  nodejs_26,
  pkg-config,
  node-gyp,
  makeBinaryWrapper,
  vips,
  faketty,
  nixosTests,
  openssl,
  bash,
}:

let
  prisma-engines_4 = callPackage ./prisma-engines_4/prisma-engines_4.nix { };
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
    makeBinaryWrapper
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
    makeBinaryWrapper ${lib.getExe nodejs_26} "$out/bin/scholarsome" \
      --add-flags "$out/lib/node_modules/scholarsome/dist/apps/api/main.js" \
      --prefix PATH : ${lib.makeBinPath [ openssl ]} \
      --set NODE_ENV production \
      --set PRISMA_MIGRATION_ENGINE_BINARY "${lib.getExe' prisma-engines_4 "migration-engine"}" \
      --set PRISMA_QUERY_ENGINE_LIBRARY "${lib.getLib prisma-engines_4}/lib/libquery_engine.node"

    # Since the Scholarsome module needs to perform this task, we'll create a wrapper,
    # so that the module doesn't have to point to `prisma-engines_4` nor `nodejs_26`.
    # We have to add `nodejs_26` to the path explicitly because of `package.json` :
    #   > "migrate": "npx prisma migrate deploy"
    makeBinaryWrapper ${lib.getExe' nodejs_26 "npm"} "$out/bin/scholarsome-migrate" \
      --chdir "$out/lib/node_modules/scholarsome" \
      --add-flags "run migrate" \
      --prefix PATH : "${
        lib.makeBinPath [
          nodejs_26
          openssl
          bash # npm needs bash available during prisma migration
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
