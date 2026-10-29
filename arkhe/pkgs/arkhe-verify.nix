{ mkArkhePackage, src, contentAddressed, version }:

mkArkhePackage {
  pname = "arkhe-verify";
  crate = "arkhe-verify-cli";
  bin = "arkhe-verify";
  inherit src contentAddressed version;

  # Testes do crate são puros (golden vectors locais).
  doCheck = true;

  cargoTestFlags = [ "-p" "arkhe-verify-core" "-p" "arkhe-core" ];

  meta = {
    description = "Verificador offline Arkhe (CLI)";
    longDescription = ''
      Executa a verificação de envelopes, provas MMR e bundles de checkpoint
      Arkhe sem acesso à rede. É o verificador de referência do perfil
      `arkhe-verify`.
    '';
  };
}
