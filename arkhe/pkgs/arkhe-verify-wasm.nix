# WASM compilado com o rust-std wasm32 da toolchain fixada, lld e bindings
# Node.js. `wasm-bindgen-cli` precisa ter exatamente a versão do crate
# `wasm-bindgen` no Cargo.lock; divergência é erro de avaliação.
{
  lib,
  mkArkhePackage,
  src,
  contentAddressed,
  version,
  lockFile,
  lld,
  wasm-bindgen-cli,
}:

let
  lockedBindgen =
    (lib.findFirst (p: p.name == "wasm-bindgen") (throw "nixpkgs-arkhe: wasm-bindgen ausente do Cargo.lock")
      (lib.importTOML lockFile).package
    ).version;
in
assert lib.assertMsg (wasm-bindgen-cli.version == lockedBindgen)
  "nixpkgs-arkhe: wasm-bindgen-cli ${wasm-bindgen-cli.version} != wasm-bindgen ${lockedBindgen} do Cargo.lock";

mkArkhePackage {
  pname = "arkhe-verify-wasm";
  crate = "arkhe-verify-wasm";
  bin = null;
  inherit src contentAddressed version;

  doCheck = false;
  nativeBuildInputs = [ lld wasm-bindgen-cli ];

  extraAttrs = {
    CARGO_TARGET_WASM32_UNKNOWN_UNKNOWN_LINKER = "${lld}/bin/wasm-ld";

    # Só o alvo wasm32: o cargoBuildHook padrão também compilaria para o host.
    buildPhase = ''
      runHook preBuild
      cargo build --locked --offline --release -j "$NIX_BUILD_CORES" \
        -p arkhe-verify-wasm --lib --target wasm32-unknown-unknown
      runHook postBuild
    '';

    dontCargoInstall = true;
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
      `arkhe-verify.wasm` para uso em portais e kiosks.
    '';
  };
}
