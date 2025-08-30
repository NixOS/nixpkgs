{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-migrate";
  version = "4.19.0";

  src = fetchFromGitHub {
    owner = "golang-migrate";
    repo = "migrate";
    rev = "v${version}";
    sha256 = "sha256-u8lP1mQLZ3WtX8NV8mnlNut5bLqkWk2blaoYJPOQoCk=";
  };

  proxyVendor = true; # darwin/linux hash mismatch
  vendorHash = "sha256-aAtPYD8gZReUJu+oOkuZ1afUKnGvP5shXCo7FgigBDI=";

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
