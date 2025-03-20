{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-migrate";
  version = "4.18.2";

  src = fetchFromGitHub {
    owner = "golang-migrate";
    repo = "migrate";
    rev = "v${version}";
    sha256 = "sha256-DRWJ5USabSQtNkyDjz8P7eOS2QBE1KaD8K8XYORBVGo=";
  };

  proxyVendor = true; # darwin/linux hash mismatch
  vendorHash = "sha256-0SbhHA5gKzODW8rHCEuZXWs8vMsVDMqJsRDPs4V1gGc=";

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

  meta = with lib; {
    homepage = "https://github.com/golang-migrate/migrate";
    description = "Database migrations. CLI and Golang library";
    maintainers = with maintainers; [ offline ];
    license = licenses.mit;
    mainProgram = "migrate";
  };
}
