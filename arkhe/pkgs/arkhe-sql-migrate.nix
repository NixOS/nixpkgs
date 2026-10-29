{ mkArkhePackage, src, contentAddressed, version }:

mkArkhePackage {
  pname = "arkhe-sql-migrate";
  crate = "arkhe-sql-migrate";
  bin = "arkhe-sql-migrate";
  inherit src contentAddressed version;

  # Migrações exigem um PostgreSQL acessível.
  doCheck = false;

  meta = {
    description = "Executor de migrações SQL do Arkhe";
  };
}
