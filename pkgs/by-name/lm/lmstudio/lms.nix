{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs_25,
  bun,
  cacert,
}:
let
  rev = "6115b40e54f94171a1618c1825a3bc716974935b";
  lmsCliRev = "0b2a176";

  src = fetchFromGitHub {
    owner = "lmstudio-ai";
    repo = "lmstudio-js";
    inherit rev;
    hash = "sha256-ZuDKjdORsBlzO69j5XZ9hPwWtCGu8pcivG+FPIcOsC0=";
    fetchSubmodules = true;
  };

  # Fixed-output derivation to fetch npm dependencies
  npmDeps = stdenv.mkDerivation {
    pname = "lms-npm-deps";
    version = "0.3.43";

    inherit src;

    nativeBuildInputs = [ nodejs_25 cacert ];

    buildPhase = ''
      export HOME=$TMPDIR
      npm install --ignore-scripts
    '';

    installPhase = ''
      # Remove ALL broken symlinks (workspace links point to source tree paths)
      find node_modules -type l ! -exec test -e {} \; -print -delete
      mv node_modules $out
    '';

    # Workspace symlinks pointing to publish/ and scaffolds/ dirs are fine to remove
    # but we also need to remove top-level workspace package dirs (lms, lmstudio)
    dontFixup = true;

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = if stdenv.hostPlatform.isDarwin
      then "sha256-Nwr4z3qKbcl1DxlSRwaCn6gRhvQr4Jz3bMY9fmbQnvo="
      else "sha256-PdJBe6K9AvkM5iAv7wL1bdSdesDSMO6ewx0S+yc7sOU=";

    impureEnvVars = lib.fetchers.proxyImpureEnvVars;
  };
in
stdenv.mkDerivation {
  pname = "lms";
  version = "0.3.43";

  inherit src;

  patchPhase = ''
    runHook prePatch
    patch -p1 -d packages/lms-cli < ${./lms-foreground.patch}
    patch -p1 < ${./lmstudio-js-foreground.patch}
    runHook postPatch
  '';

  nativeBuildInputs = [ nodejs_25 bun ];

  env.TURBO_TELEMETRY_DISABLED = "1";
  env.DO_NOT_TRACK = "1";

  buildPhase = ''
    runHook preBuild

    # Link pre-fetched dependencies
    cp -r ${npmDeps} node_modules
    chmod -R u+w node_modules

    # Fix shebangs in .bin scripts (they use #!/usr/bin/env which doesn't exist in sandbox)
    patchShebangs node_modules

    # Re-create workspace symlinks that were removed from the FOD
    for pkg in packages/lms-cli packages/lms-client packages/lms-common-server \
               packages/lms-common packages/lms-communication-client \
               packages/lms-communication-mock packages/lms-communication-server \
               packages/lms-communication packages/lms-es-plugin-runner \
               packages/lms-external-backend-interfaces packages/lms-isomorphic \
               packages/lms-json-schema packages/lms-kv-config packages/lms-lmstudio \
               packages/lms-shared-types packages/template \
               publish/cli publish/lms publish/lmstudio publish/sdk \
               scaffolds/node-typescript scaffolds/node-typescript-empty; do
      name=$(node -e "try{console.log(require('./$pkg/package.json').name)}catch(e){}")
      if [ -n "$name" ] && [ -d "$pkg" ]; then
        scope_dir="node_modules/$(dirname "$name")"
        mkdir -p "$scope_dir"
        ln -sfn "$(pwd)/$pkg" "node_modules/$name"
      fi
    done

    # 1. Generate ESM package.json shims
    npm run gen

    # 2. Build all workspace packages
    npx tsc --build tsconfig.build.json

    # 3. Build the SDK (needed by lms-cli)
    npx turbo run build --filter=@lmstudio/sdk

    # 4. Build lms-cli TypeScript
    npx turbo run build --filter=@lmstudio/lms-cli

    # 5. Bundle with rollup and inject commit hash
    cd publish/cli
    npm run build-rollup
    # injectVariables.js needs git; do the replacement directly instead
    substituteInPlace dist/index.js \
      --replace-quiet '<LMS-CLI-COMMIT-HASH>' '${lmsCliRev}'

    # 6. Compile with bun
    bun build dist/index.js --compile --outfile dist/lms

    runHook postBuild
  '';

  # The bun-compiled binary has embedded JS — stripping destroys it
  dontStrip = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 dist/lms $out/bin/lms
    runHook postInstall
  '';

  meta = {
    description = "LM Studio CLI";
    homepage = "https://github.com/lmstudio-ai/lms";
    license = lib.licenses.mit;
    mainProgram = "lms";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
