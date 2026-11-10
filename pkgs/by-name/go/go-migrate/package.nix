{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
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

  ldflags = [
    "-s"
    "-X main.Version=${finalAttrs.version}"
  ];

  tags = [
    # Remote source drivers
    "aws_s3"
    "bitbucket"
    "github" # Also builds github_ee
    "gitlab"
    "go_bindata"
    "godoc_vfs"
    "google_cloud_storage"
    # Database drivers
    "cassandra"
    "clickhouse"
    "cockroachdb"
    "firebird"
    "mongodb"
    "mysql"
    "neo4j"
    "pgx"
    "pgx5"
    "postgres"
    "ql"
    "redshift"
    "rqlite"
    "spanner"
    "sqlite3"
    "sqlserver"
    "yugabytedb"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    homepage = "https://github.com/golang-migrate/migrate";
    description = "Database migrations. CLI and Golang library";
    maintainers = with lib.maintainers; [ kleinbem ];
    license = lib.licenses.mit;
    mainProgram = "migrate";
  };
})
