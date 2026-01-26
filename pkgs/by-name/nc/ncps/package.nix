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
}:

let
  dbmate-real = writeShellScriptBin "dbmate.real" ''
    exec ${dbmate}/bin/dbmate "$@"
  '';

  dbmate-wrapper = buildGoModule {
    pname = "ncps-dbmate-wrapper";
    inherit (finalAttrs) version;

    src = "${finalAttrs.src}/nix/dbmate-wrapper/src";

    vendorHash = null;

    subPackages = [ "." ];
  };

  finalAttrs = {
    pname = "ncps";
    version = "0.7.2";

    src = fetchFromGitHub {
      owner = "kalbasit";
      repo = "ncps";
      tag = "v${finalAttrs.version}";
      hash = "sha256-qc6h1gnU7dFyb0GiBq++E2yf49K7mO86Vwdf8y3817U=";
    };

    vendorHash = "sha256-nnt4HIG4Fs7RhHjVb7mYJ39UgvFKc46Cu42cURMmr1s=";

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

      makeWrapper ${dbmate-wrapper}/bin/dbmate-wrapper \
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
  };
in
buildGoModule finalAttrs
