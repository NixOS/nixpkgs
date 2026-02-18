{
  buildGoModule,
  curl,
  dbmate,
  fetchFromGitHub,
  jq,
  lib,
  makeWrapper,
  mariadb,
  minio,
  minio-client,
  postgresql,
  python3,
  redis,
  writeShellScriptBin,
  nixosTests,
  nix-update-script,
}:

let
  dbmate-real = writeShellScriptBin "dbmate.real" ''
    exec ${dbmate}/bin/dbmate "$@"
  '';
in
buildGoModule (finalAttrs: {
  pname = "ncps";
  version = "0.8.6";

  src = fetchFromGitHub {
    owner = "kalbasit";
    repo = "ncps";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ep83aGlwf8qq7fmSCCH9zUztlXf4D3vvs9jkBBoN6Yw=";
  };

  vendorHash = "sha256-AcgC+zTS3eVsbcs0jim4zDBGc3lIjwPbdVT7/KQ9Lkc=";

  ldflags = [
    "-X github.com/kalbasit/ncps/pkg/ncps.Version=v${finalAttrs.version}"
  ];

  subPackages = [ "." ];

  nativeBuildInputs = [
    curl # used for checking MinIO health check
    dbmate # used for testing
    jq # used for testing by the init-minio
    mariadb # MySQL/MariaDB for integration tests
    minio # S3-compatible storage for integration tests
    minio-client # mc CLI for MinIO setup
    postgresql # PostgreSQL for integration tests
    python3 # used for generating the ports
    redis # Redis for distributed locking integration tests
    makeWrapper # For wrapping dbmate.
  ];

  postInstall = ''
    mkdir -p $out/share/ncps
    cp -r db $out/share/ncps/db

    makeWrapper ${finalAttrs.passthru.dbmate-wrapper}/bin/dbmate-wrapper \
      $out/bin/dbmate-ncps \
      --prefix PATH : ${dbmate-real}/bin \
      --set NCPS_DB_MIGRATIONS_DIR $out/share/ncps/db/migrations
  '';

  doCheck = true;

  checkFlags = [ "-race" ];

  # pre and post checks
  preCheck = ''
    # Set up cleanup trap to ensure background processes are killed even if tests fail
    cleanup() {
      source $src/nix/packages/ncps/post-check-minio.sh
      source $src/nix/packages/ncps/post-check-mysql.sh
      source $src/nix/packages/ncps/post-check-postgres.sh
      source $src/nix/packages/ncps/post-check-redis.sh
    }
    trap cleanup EXIT

    source $src/nix/packages/ncps/pre-check-minio.sh
    source $src/nix/packages/ncps/pre-check-mysql.sh
    source $src/nix/packages/ncps/pre-check-postgres.sh
    source $src/nix/packages/ncps/pre-check-redis.sh
  '';

  passthru = {
    dbmate-wrapper = buildGoModule {
      pname = "ncps-dbmate-wrapper";
      inherit (finalAttrs) version;

      src = "${finalAttrs.src}/nix/dbmate-wrapper/src";

      vendorHash = null;

      subPackages = [ "." ];
    };

    tests = {
      inherit (nixosTests)
        ncps
        ncps-custom-sqlite-directory
        ncps-custom-storage-local
        ncps-ha-pg
        ncps-ha-pg-redis
        ;
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Nix binary cache proxy service";
    homepage = "https://github.com/kalbasit/ncps";
    license = lib.licenses.mit;
    mainProgram = "ncps";
    maintainers = with lib.maintainers; [
      kalbasit
      aciceri
    ];
  };
})
