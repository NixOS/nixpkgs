{
  rustPlatform,
  python3,
  pkg-config,
  binaryen,
  bzip2,
  zstd,
  wasm-bindgen-cli_0_2_129,
  wasm-pack,
  nodejs,
  typescript_7,
  lld,
  writableTmpDirAsHomeHook,

  ironcalc,
}:
rustPlatform.buildRustPackage {
  pname = "ironcalc-wasm";
  inherit (ironcalc) version src cargoHash;

  nativeBuildInputs = [
    binaryen
    pkg-config
    python3
    wasm-bindgen-cli_0_2_129
    wasm-pack
    nodejs
    typescript_7
    lld
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    bzip2
    zstd
  ];

  buildPhase = ''
    cd bindings/wasm
    make tests

    wasm-pack build --target web --scope ironcalc --release
    cp README.pkg.md pkg/README.md
    tsc types.ts --target esnext --module esnext
    python3 fix_types.py
    rm -f types.js

    # wasm-pack generates a package.json, we must provide one
    cat > pkg/package.json <<EOF
    {
      "name": "@ironcalc/wasm",
      "version": "${ironcalc.version}",
      "type": "module",
      "files": [
        "wasm_bg.wasm",
        "wasm.js",
        "wasm.d.ts"
      ],
      "main": "wasm.js",
      "module": "wasm.js",
      "types": "wasm.d.ts",
      "exports": {
        ".": {
          "types": "./wasm.d.ts",
          "import": "./wasm.js"
        }
      },
      "sideEffects": false
    }
    EOF
  '';

  doCheck = true;

  installPhase = ''
    cp -r pkg $out
  '';

  __structuredAttrs = true;
  strictDeps = true;

  meta = ironcalc.meta // {
    description = "Ironcalc wasm bindings";
  };
}
