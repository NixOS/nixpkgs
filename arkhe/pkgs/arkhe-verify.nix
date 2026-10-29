{ mkArkhePackage, src, contentAddressed, version }:

mkArkhePackage {
  pname = "arkhe-verify";
  crate = "arkhe-verify-cli";
  bin = "arkhe-verify";
  inherit src contentAddressed version;

  # Testes do crate são puros (golden vectors locais).
  doCheck = true;
  testCrates = [ "arkhe-verify-core" "arkhe-core" ];

  # O binário só é aceito se os golden vectors AKG-CBOR-v1 passarem com o
  # mesmo compilador e as mesmas dependências que o produziram.
  requiredTests = [
    { crate = "arkhe-core"; test = "golden_vectors"; }
    { crate = "arkhe-verify-core"; test = "golden_contract"; }
  ];

  meta = {
    description = "Verificador offline Arkhe (CLI)";
    longDescription = ''
      Executa a verificação de envelopes, provas MMR e bundles de checkpoint
      Arkhe sem acesso à rede. É o verificador de referência do perfil
      `arkhe-verify`.
    '';
  };
}
