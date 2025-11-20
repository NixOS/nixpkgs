{
  stdenv,
  rustPlatform,
  fetchNpmDeps,

  bencher,
  binaryen,
  cargo,
  clang,
  lld,
  makeWrapper,
  nodejs,
  npmHooks,
  rustc,
  wasm-bindgen-cli_0_2_100,
  wasm-pack,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bencher-console";
  version = bencher.version;

  inherit (bencher) meta src;

  npmRoot = "services/console";
  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-npm-deps";
    inherit (finalAttrs) version src;
    sourceRoot = "${finalAttrs.src.name}/${finalAttrs.npmRoot}";
    hash = "sha256-bOy+H5JLOw4LmPkogeyBLYGe61PuHdQgxgJRHux83ro=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = bencher.cargoHash;
  };

  nativeBuildInputs = [
    binaryen
    cargo
    clang
    lld
    nodejs
    npmHooks.npmConfigHook
    rustc
    rustPlatform.cargoSetupHook
    wasm-bindgen-cli_0_2_100
    wasm-pack
    makeWrapper
  ];
  buildPhase = ''
    runHook preBuild

    cd services/console

    substituteInPlace astro.config.mjs \
      --replace-fail '// import node from "@astrojs/node";' 'import node from "@astrojs/node";' \
      --replace-fail 'adapter: undefined' 'adapter: node({mode: "standalone"})'

    wasm-pack build ../../lib/bencher_valid --target web --release --no-default-features --features wasm

    npm run build

    substituteInPlace dist/server/entry.mjs \
      --replace-fail 'file:///build/source/services/console/dist/client' "file://$out/client" \
      --replace-fail 'file:///build/source/services/console/dist/server' "file://$out/server"

    runHook postBuild
  '';

  installPhase = ''
    sed -i '1s|^|#!/usr/bin/env node\n|' dist/server/entry.mjs
    chmod +x  dist/server/entry.mjs
    patchShebangs dist/server/entry.mjs

    mkdir -p $out
    cp -r dist/{client,server} node_modules $out

    makeWrapper $out/server/entry.mjs $out/bin/bencher-console \
      --set-default IS_BENCHER_CLOUD false \
      --set-default GOOGLE_ANALYTICS_ID "" \
      --set-default PUBLIC_SENTRY_DSN "" \
      --set-default BENCHER_API_URL "https://localhost:61016"
  '';
})
