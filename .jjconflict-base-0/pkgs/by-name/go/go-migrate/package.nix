{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "go-migrate";
  version = "4.20.1";

  src = fetchFromGitHub {
    owner = "golang-migrate";
    repo = "migrate";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-t65zqD0oQ/E3VxKOGkKIZRm6eFCT9ISnZ4vFzq5rNho=";
  };

  proxyVendor = true; # darwin/linux hash mismatch
  vendorHash = "sha256-CnQvMhaXZ2IY1K8dMQRsvd7KzLb4F4xczLTieX477Ig=";

  subPackages = [ "cmd/migrate" ];

  tags = [
    "cassandra"
    "clickhouse"
    "cockroachdb"
    "crate"
    "firebird"
    "mongodb"
    "multistmt"
    "mysql"
    "neo4j"
    "pgx"
    "pgx5"
    "postgres"
    "ql"
    "redshift"
    "rqlite"
    "shell"
    "snowflake"
    "spanner"
    "sqlite3"
    "sqlserver"
    "stub"
    "testing"
    "yugabytedb"
  ];

  meta = {
    homepage = "https://github.com/golang-migrate/migrate";
    description = "Database migrations. CLI and Golang library";
    maintainers = [ ];
    license = lib.licenses.mit;
    mainProgram = "migrate";
  };
})
