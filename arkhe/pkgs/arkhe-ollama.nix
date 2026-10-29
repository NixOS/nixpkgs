{ mkArkhePackage, src, contentAddressed, version }:

mkArkhePackage {
  pname = "arkhe-ollama";
  crate = "arkhe-ollama";
  bin = "arkhe-ollama";
  inherit src contentAddressed version;

  # Testes sobem servidor axum local.
  doCheck = false;

  meta = {
    description = "Provider Ollama local do Arkhe";
  };
}
