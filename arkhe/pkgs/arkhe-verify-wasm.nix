# WASM compilado com std do rustc fixado, lld e bindings Node.js.
{ mkArkhePackage, src, contentAddressed, version, lld, wasm-bindgen-cli }:

mkArkhePackage {
  pname = "arkhe-verify-wasm";
  crate = "arkhe-verify-wasm";
  bin = null;
  inherit src contentAddressed version;

  doCheck = false;
  nativeBuildInputs = [ lld wasm-bindgen-cli ];

  cargoBuildFlags = [
    "--lib"
    "--target"
    "wasm32-unknown-unknown"
  ];

  extraAttrs = {
    CARGO_BUILD_TARGET = "wasm32-unknown-unknown";
    CARGO_TARGET_WASM32_UNKNOWN_UNKNOWN_LINKER = "${lld}/bin/wasm-ld";

    installPhase = ''
      runHook preInstall
      mkdir -p $out/lib
      cp target/wasm32-unknown-unknown/release/arkhe_verify_wasm.wasm \
        $out/lib/arkhe-verify.wasm
      wasm-bindgen $out/lib/arkhe-verify.wasm --target nodejs \
        --out-dir $out/lib --out-name arkhe_verify
      runHook postInstall
    '';
  };

  meta = {
    description = "Verificador Arkhe compilado para WebAssembly";
    longDescription = ''
      Mesmo crate de verificação usado pelo RBB, exportado como
      `arkhe-verify-pqc.wasm` para uso em portais e kiosks.
    '';
  };
}
