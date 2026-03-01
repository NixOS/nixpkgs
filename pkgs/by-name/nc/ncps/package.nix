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
  nix-update-script,
  nixosTests,
  postgresql,
  python3,
  redis,
  writeShellScriptBin,
  xz,
}:

buildGoModule (finalAttrs: {
  pname = "ncps";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "kalbasit";
    repo = "ncps";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LRabKv+4xYQn2XH4AIacFkn3ewUd2S3UlVWCA6MUweU=";
  };

  vendorHash = "sha256-PpHSkD7+csPfUXoYRuKhBm1iBtTSwJhOxuW/4ayv9hY=";

  ldflags = [
    "-X github.com/kalbasit/ncps/pkg/ncps.Version=v${finalAttrs.version}"
  ];

  excludedPackages = [
    "nix/dbmate-wrapper/src"
    "nix/gen-db-wrappers/src"
  ];

  buildInputs = [ xz ];

  nativeBuildInputs = [
    makeWrapper # used for wrapping the binary so it can always find the xz binary

    curl # used for checking MinIO health check
    dbmate # used for testing
    jq # used for testing by the init-minio
    mariadb # MySQL/MariaDB for integration tests
    minio # S3-compatible storage for integration tests
    minio-client # mc CLI for MinIO setup
    postgresql # PostgreSQL for integration tests
    python3 # used for generating the ports
    redis # Redis for distributed locking integration tests
  ];

  postInstall = ''
    mkdir -p $out/share/ncps
    cp -r db $out/share/ncps/db

    # ncps makes use of xz for decompression as it's 3-5x faster than
    # using the native Go implementation of xz. By wrapping ncps, and
    # setting the XZ_BINARY_PATH environment variable, we ensure that
    # ncps can always find the xz binary. This environment variable is
    # read by a flag in pkg/ncps and can be overriden by using calling
    # ncps with the --xz-binary-path flag.
    wrapProgram $out/bin/ncps --set XZ_BINARY_PATH ${lib.getExe' xz "xz"}

    # Wrap the dbmate-wrapper and set the NCPS_DB_MIGRATIONS_DIR environment variable
    makeWrapper ${finalAttrs.passthru.dbmate-wrapper}/bin/dbmate-wrapper \
      $out/bin/dbmate-ncps \
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

      buildInputs = lib.singleton dbmate;
      nativeBuildInputs = lib.singleton makeWrapper;

      postInstall = ''
        # the dbmate-wrapper needs access to the original dbmate executable, wrap it so it can find it correctly.
        wrapProgram $out/bin/dbmate-wrapper --set DBMATE_BIN ${lib.getExe dbmate}
      '';

      subPackages = [ "." ];
    };

    tests = {
      inherit (nixosTests)
        ncps
        ncps-custom-sqlite-directory
        ncps-custom-storage-local
        ncps-ha-pg-redis
        ncps-ha-pg-redis-cdc
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
