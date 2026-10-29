# Artefato WASM do verificador.
#
# Ressalva importante: o rustc do nixpkgs normalmente instala apenas a std do
# host. Compilar para `wasm32-unknown-unknown` exige uma toolchain que traga
# essa std (por exemplo um `rustPlatform` vindo de rust-overlay). Por isso este
# atributo existe, mas NÃO entra em `checks` nem no build padrão do CI.
{ mkArkhePackage, src, contentAddressed, version }:

mkArkhePackage {
  pname = "arkhe-verify-wasm";
  crate = "arkhe-verify-wasm";
  bin = null;
  inherit src contentAddressed version;

  doCheck = false;

  cargoBuildFlags = [
    "--lib"
    "--target"
    "wasm32-unknown-unknown"
  ];

  extraAttrs = {
    CARGO_BUILD_TARGET = "wasm32-unknown-unknown";

    installPhase = ''
      runHook preInstall
      mkdir -p $out/lib
      cp target/wasm32-unknown-unknown/release/arkhe_verify_wasm.wasm \
        $out/lib/arkhe-verify-pqc.wasm
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
