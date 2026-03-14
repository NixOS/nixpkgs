{
  binaryen,
  extism-cli,
  lib,
  pkg-config,
  pkgsCross,
  rustPlatform,
  testers,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  zstd,
}:

let
  inherit (pkgsCross.wasi32) extism-js-core;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "extism-js";

  inherit (extism-js-core)
    version
    src
    cargoDeps
    postPatch
    ;

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    zstd
  ];

  # fs-set-times v0.20.3 uses #![feature]
  env.RUSTC_BOOTSTRAP = 1;

  env.EXTISM_ENGINE_PATH = "${pkgsCross.wasi32.extism-js-core}/bin/js_pdk_core.wasm";
  env.ZSTD_SYS_USE_PKG_CONFIG = true;

  cargoBuildFlags = [ "--package=js-pdk-cli" ];
  cargoTestFlags = [ "--package=js-pdk-cli" ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru = {
    tests.simple-js = testers.runCommand {
      # Based on https://github.com/extism/js-pdk/tree/v1.6.0/examples/simple_js
      name = "${finalAttrs.pname}-simple-js-test";
      nativeBuildInputs = [
        finalAttrs.finalPackage

        binaryen
        extism-cli
        writableTmpDirAsHomeHook
      ];
      script = ''
        cat <<'EOF' > script.js
        function helloWorld() {
          Host.outputString(`Hello, ''${Host.inputString()}!`);
        }

        module.exports = { helloWorld };
        EOF

        cat <<EOF > script.d.ts
        declare module "main" {
          export function helloWorld(): I32;
        }
        EOF

        cat <<EOF > expected
        Hello, nixpkgs!
        EOF

        extism-js script.js -i script.d.ts -o script.wasm
        extism call script.wasm helloWorld --wasi --input="nixpkgs" > output

        diff output expected && touch $out
      '';
    };
  };

  __structuredAttrs = true;

  meta = {
    changelog = "https://github.com/extism/js-pdk/releases/tag/v${finalAttrs.version}";
    description = "Write Extism plugins in JavaScript & TypeScript (CLI)";
    mainProgram = "extism-js";
    platforms = lib.platforms.unix;
    inherit (extism-js-core.meta) homepage license maintainers;
  };
})
