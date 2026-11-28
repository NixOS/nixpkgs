{
  lib,
  fetchFromGitHub,
  fetchPnpmDeps,
  gnused,
  nodejs_22,
  pnpm_10,
  runCommand,
  stdenv,
  zstd,
}:
let
  pnpm = pnpm_10;

  version = "0.48.1";

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "stripe-sync-engine";
    tag = "v${version}";
    hash = "sha256-ihWr5IWklFkmxO91gO9ENCbb3GhHBtIRQIRCLzb2Ak8=";
  };

  # Patched source that allows the nixpkgs pnpm version and removes .npmrc
  # which expects an $NPM_TOKEN
  patchedSrc = runCommand "stripe-sync-engine-src-patched" { } ''
    cp -r ${src} $out
    chmod -R +w $out
    # Update packageManager to match nixpkgs pnpm version
    ${lib.getExe gnused} -i \
      -e 's/"packageManager": "pnpm@[^"]*"/"packageManager": "pnpm@${pnpm.version}"/' \
      $out/package.json
    rm $out/.npmrc
  '';

  # Fetch pnpm dependencies as a separate fixed-output derivation
  pnpmDeps = fetchPnpmDeps {
    pname = "stripe-sync-engine-pnpm-deps";
    inherit version;
    src = patchedSrc;
    fetcherVersion = 3;
    hash = "sha256-5MVbNgIlQUnplKDlQ40puda7jMziTuDrYiQM6cjPJg0=";
  };
in
stdenv.mkDerivation {
  pname = "stripe-sync-engine";
  inherit version;
  src = patchedSrc;

  nativeBuildInputs = [
    nodejs_22
    pnpm
    zstd
  ];

  # Disable unnecessary fixup phases
  dontStrip = true;
  dontPatchShebangs = true;
  dontPatchELF = true;

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    export STORE_PATH=$(mktemp -d)

    # Extract the pre-fetched pnpm store
    echo "Extracting pnpm store..."
    tar --zstd -xf "${pnpmDeps}/pnpm-store.tar.zst" -C "$STORE_PATH"
    chmod -R +w "$STORE_PATH"

    # Configure pnpm
    pnpm config set store-dir "$STORE_PATH"
    pnpm config set package-import-method clone-or-copy
    pnpm config set manage-package-manager-versions false

    # Install dependencies for all workspace packages
    echo "Installing dependencies..."
    pnpm install --offline --frozen-lockfile --ignore-scripts

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/stripe-sync-engine

    cp -r packages $out/lib/stripe-sync-engine/
    cp -r node_modules $out/lib/stripe-sync-engine/
    cp package.json $out/lib/stripe-sync-engine/

    mkdir -p $out/bin
    cat > $out/bin/stripe-sync-engine <<EOF
    #!/usr/bin/env bash
    cd $out/lib/stripe-sync-engine/packages/fastify-app
    exec ${nodejs_22}/bin/node dist/src/server.js "\$@"
    EOF
    chmod +x $out/bin/stripe-sync-engine

    runHook postInstall
  '';

  meta = {
    description = "Sync your Stripe account to your Postgres database";
    homepage = "https://github.com/supabase/stripe-sync-engine";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.lgug2z ];
    platforms = lib.platforms.unix;
  };
}
