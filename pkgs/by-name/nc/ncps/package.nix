{
  buildGoModule,
  curl,
  dbmate,
  fetchFromGitHub,
  lib,
  minio,
  minio-client,
  python3,
}:

let

  # Start MinIO before running tests to enable S3 integration tests
  minioPreCheck = ''
    echo "🚀 Starting MinIO for S3 integration tests..."

    # Create temporary directories for MinIO data and config
    export MINIO_DATA_DIR=$(mktemp -d)
    export HOME=$(mktemp -d)

    # Configure MinIO credentials (must be set before starting MinIO)
    export MINIO_ROOT_USER=admin
    export MINIO_ROOT_PASSWORD=password
    export MINIO_REGION=us-east-1

    # Generate random free ports using python
    # We bind to port 0, get the assigned port, and close the socket immediately.
    # In a Nix sandbox, the race condition risk (port being stolen between check and use) is negligible.
    export MINIO_PORT=$(python3 -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
    export CONSOLE_PORT=$(python3 -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')

    # Export S3 test environment variables
    export NCPS_TEST_S3_BUCKET="test-bucket"
    export NCPS_TEST_S3_ENDPOINT="http://127.0.0.1:$MINIO_PORT"
    export NCPS_TEST_S3_REGION="us-east-1"
    export NCPS_TEST_S3_ACCESS_KEY_ID="test-access-key"
    export NCPS_TEST_S3_SECRET_ACCESS_KEY="test-secret-key"

    # Start MinIO server in background
    minio server "$MINIO_DATA_DIR" \
      --address "127.0.0.1:$MINIO_PORT" \
      --console-address "127.0.0.1:$CONSOLE_PORT" &
    export MINIO_PID=$!

    # Wait for MinIO to be ready
    echo "⏳ Waiting for MinIO to be ready..."
    for i in {1..30}; do
      if curl -sf "$NCPS_TEST_S3_ENDPOINT/minio/health/live"; then
        echo "✅ MinIO is ready"
        break
      fi
      if [ $i -eq 30 ]; then
        echo "❌ MinIO failed to start"
        kill $MINIO_PID 2>/dev/null || true
        exit 1
      fi
      sleep 1
    done

    # Setup admin alias
    mc alias set local "$NCPS_TEST_S3_ENDPOINT" "$MINIO_ROOT_USER" "$MINIO_ROOT_PASSWORD"

    # Create test bucket
    mc mb "local/$NCPS_TEST_S3_BUCKET" || true

    # Create service account for tests
    mc admin user svcacct add \
      --access-key "$NCPS_TEST_S3_ACCESS_KEY_ID" \
      --secret-key "$NCPS_TEST_S3_SECRET_ACCESS_KEY" \
      local admin || true

    echo "✅ MinIO configured for S3 integration tests"
  '';

  # Stop MinIO after tests complete
  minioPostCheck = ''
    echo "🛑 Stopping MinIO..."
    if [ -n "$MINIO_PID" ]; then
      kill $MINIO_PID 2>/dev/null || true
      # Wait for MinIO to fully shut down
      for i in {1..30}; do
        if ! kill -0 $MINIO_PID 2>/dev/null; then
          break
        fi
        sleep 0.5
      done

      # If it's still alive, force kill it
      if kill -0 $MINIO_PID 2>/dev/null; then
        echo "MinIO did not shut down gracefully, force killing..."
        kill -9 $MINIO_PID 2>/dev/null || true
        sleep 1 # Give a moment for the OS to clean up after SIGKILL
      fi
    fi
    sleep 1
    rm -rf "$MINIO_DATA_DIR" 2>/dev/null || true
    echo "✅ MinIO stopped and cleaned up"
  '';

  finalAttrs = {
    pname = "ncps";
    version = "0.5.2";

    src = fetchFromGitHub {
      owner = "kalbasit";
      repo = "ncps";
      tag = "v${finalAttrs.version}";
      hash = "sha256-uGghoADkD2eJYZwt8QSiVzw68dRDLI+OxMa1VAQhBKQ=";
    };

    ldflags = [
      "-X github.com/kalbasit/ncps/cmd.Version=v${finalAttrs.version}"
    ];

    vendorHash = "sha256-3YPKlz7+x7nYCqKmOroaiUyZGKIQMGFxcNyPnrA9Tio=";

    doCheck = true;
    checkFlags = [ "-race" ];

    nativeBuildInputs = [
      curl # used for checking MinIO health check
      dbmate # used for testing
      minio # S3-compatible storage for integration tests
      minio-client # mc CLI for MinIO setup
      python3 # used for generating the ports
    ];

    # pre and post checks
    preCheck = ''
      # Set up cleanup trap to ensure background processes are killed even if tests fail
      cleanup() {
        ${minioPostCheck}
      }
      trap cleanup EXIT

      ${minioPreCheck}
    '';

    postInstall = ''
      mkdir -p $out/share/ncps
      cp -r db $out/share/ncps/db
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
