{
  lib,
  stdenv,
  pnpm,
  pnpmConfigHook,
  fetchPnpmDeps,
  rustPlatform,
  pkg-config,
  bzip2,
  zstd,
  ironcalc,
  nodejs,
  cargo,
  rustc,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation {
  pname = "ironcalc-nodejs";
  inherit (ironcalc) version src;

  postPatch = ''
    cd bindings/nodejs
  '';

  strictDeps = true;
  __structuredAttrs = true;

  pnpmDeps = fetchPnpmDeps {
    inherit (ironcalc) src;
    pname = "ironcalc-nodejs";
    hash = "sha256-q0PTXKAX0mhrMKMnFzV65YU948lh+/rGn9ttWzBfdNc=";
    fetcherVersion = 3;
    preInstall = ''
      cd bindings/nodejs
    '';
  };

  makeCacheWritable = true;

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (ironcalc) src;
    hash = ironcalc.cargoHash;
  };

  cargoRoot = "../..";

  nativeBuildInputs = [
    pkg-config
    pnpm
    nodejs
    cargo
    rustc
    pnpmConfigHook
    rustPlatform.cargoSetupHook
    rustPlatform.cargoCheckHook
    writableTmpDirAsHomeHook
  ];

  buildPhase = ''
    runHook preBuild
    pnpm run build
    runHook postBuild
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    pnpm run test
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/node_modules/@ironcalc/nodejs
    cp index.js index.d.ts package.json *.node $out/lib/node_modules/@ironcalc/nodejs/
    runHook postInstall
  '';

  meta = ironcalc.meta // {
    description = "Node.js bindings for IronCalc";
  };
}
