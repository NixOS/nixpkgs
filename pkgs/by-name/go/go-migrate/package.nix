{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-migrate";
  version = "4.18.1";

  src = fetchFromGitHub {
    owner = "golang-migrate";
    repo = "migrate";
    rev = "v${version}";
    sha256 = "sha256-ZZeurnoFcObrK75zkIZvz9ycdDP9AM3uX6h/4bMWpGc=";
  };

  proxyVendor = true; # darwin/linux hash mismatch
  vendorHash = "sha256-Zaq88oF5rSCSv736afyKDvTNCSIyrIGTN0kuJWqS7tg=";

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
