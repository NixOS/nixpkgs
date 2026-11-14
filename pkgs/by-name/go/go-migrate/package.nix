{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "go-migrate";
  version = "4.19.1";

  src = fetchFromGitHub {
    owner = "golang-migrate";
    repo = "migrate";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Z8ufA2z5XeJ80Jfd6NSls/SurR8rMTO4zq88fQYGGpA=";
  };

  proxyVendor = true; # darwin/linux hash mismatch
  vendorHash = "sha256-IaTNm119GO+1DkGYHFD8A8B/rWOVy0KAiXMhKj0zC/M=";

  subPackages = [ "cmd/migrate" ];

  ldflags = [
    "-s"
    "-X main.Version=${finalAttrs.version}"
  ];

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
    "spanner"
    "sqlite3"
    "sqlserver"
    "stub"
    "testing"
    "yugabytedb"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    homepage = "https://github.com/golang-migrate/migrate";
    description = "Database migrations. CLI and Golang library";
    maintainers = [ ];
    license = lib.licenses.mit;
    mainProgram = "migrate";
  };
})
