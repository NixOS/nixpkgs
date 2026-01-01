{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-migrate";
<<<<<<< HEAD
  version = "4.19.1";
=======
  version = "4.19.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "golang-migrate";
    repo = "migrate";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-Z8ufA2z5XeJ80Jfd6NSls/SurR8rMTO4zq88fQYGGpA=";
  };

  proxyVendor = true; # darwin/linux hash mismatch
  vendorHash = "sha256-IaTNm119GO+1DkGYHFD8A8B/rWOVy0KAiXMhKj0zC/M=";
=======
    sha256 = "sha256-u8lP1mQLZ3WtX8NV8mnlNut5bLqkWk2blaoYJPOQoCk=";
  };

  proxyVendor = true; # darwin/linux hash mismatch
  vendorHash = "sha256-aAtPYD8gZReUJu+oOkuZ1afUKnGvP5shXCo7FgigBDI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/golang-migrate/migrate";
    description = "Database migrations. CLI and Golang library";
    maintainers = with lib.maintainers; [ offline ];
    license = lib.licenses.mit;
=======
  meta = with lib; {
    homepage = "https://github.com/golang-migrate/migrate";
    description = "Database migrations. CLI and Golang library";
    maintainers = with maintainers; [ offline ];
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "migrate";
  };
}
