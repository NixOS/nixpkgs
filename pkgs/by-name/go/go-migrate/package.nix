{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  runCommand,
  sqlite,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "go-migrate";
  version = "4.20.1";

  src = fetchFromGitHub {
    owner = "golang-migrate";
    repo = "migrate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t65zqD0oQ/E3VxKOGkKIZRm6eFCT9ISnZ4vFzq5rNho=";
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

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      sqlite =
        runCommand "go-migrate-sqlite-test"
          {
            nativeBuildInputs = [
              finalAttrs.finalPackage
              sqlite
            ];
          }
          ''
            mkdir migrations
            cat > migrations/1_init.up.sql <<'EOF'
            CREATE TABLE test_table (id INTEGER PRIMARY KEY, name TEXT);
            EOF
            cat > migrations/1_init.down.sql <<'EOF'
            DROP TABLE test_table;
            EOF

            migrate -path migrations -database "sqlite3://test.db" up
            sqlite3 test.db ".schema test_table" | grep -q "test_table"

            migrate -path migrations -database "sqlite3://test.db" down -all
            if sqlite3 test.db ".schema test_table" | grep -q "test_table"; then
              echo "test_table still exists after down migration" >&2
              exit 1
            fi

            touch $out
          '';
      drivers =
        runCommand "go-migrate-drivers-test"
          {
            nativeBuildInputs = [ finalAttrs.finalPackage ];
          }
          ''
            help_output=$(migrate -help 2>&1)
            source_drivers=$(sed -n 's/^Source drivers: //p' <<<"$help_output")
            database_drivers=$(sed -n 's/^Database drivers: //p' <<<"$help_output")

            for src in bitbucket file gcs github github-ee gitlab go-bindata godoc-vfs s3; do
              if ! grep -Eq "(^| )''${src}(,|$)" <<<"$source_drivers"; then
                echo "Missing source driver: $src" >&2
                exit 1
              fi
            done

            for db in clickhouse postgres postgresql sqlite3 spanner; do
              if ! grep -Eq "(^| )''${db}(,|$)" <<<"$database_drivers"; then
                echo "Missing database driver: $db" >&2
                exit 1
              fi
            done

            touch $out
          '';
    };
  };

  meta = {
    homepage = "https://github.com/golang-migrate/migrate";
    changelog = "https://github.com/golang-migrate/migrate/releases/tag/${finalAttrs.src.tag}";
    description = "CLI for database migrations";
    maintainers = with lib.maintainers; [ kleinbem ];
    license = lib.licenses.mit;
    mainProgram = "migrate";
  };
})
