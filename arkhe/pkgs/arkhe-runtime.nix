{ mkArkhePackage, src, contentAddressed, version }:

mkArkhePackage {
  pname = "arkhe-runtime";
  crate = "arkhe-runtime";
  bin = "arkhe-runtime";
  inherit src contentAddressed version;

  # Requer PostgreSQL, token e ator; não é um teste hermético.
  doCheck = false;

  meta = {
    description = "Runtime HTTP Arkhe (perfil arkhe-node)";
    longDescription = ''
      Serviço axum do kernel Arkhe. Lê DATABASE_URL, ARKHE_API_TOKEN,
      ARKHE_ACTOR, ARKHE_TENANT_ID e escuta em ARKHE_LISTEN
      (padrão 127.0.0.1:8788).
    '';
  };
}
