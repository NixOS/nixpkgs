{ mkArkhePackage, src, contentAddressed, version }:

mkArkhePackage {
  pname = "arkhe-ask";
  crate = "arkhe-ask";
  bin = "arkhe-ask";
  inherit src contentAddressed version;

  # Depende de PostgreSQL, pgvector e Kafka opcional.
  doCheck = false;

  meta = {
    description = "Serviço de perguntas verificadas Arkhe";
    longDescription = ''
      API axum com RAG sobre pgvector, autenticação Keycloak opcional e
      outbox Kafka. Escuta em ARKHE_LISTEN (padrão 127.0.0.1:3000).
    '';
  };
}
