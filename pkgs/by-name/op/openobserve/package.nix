{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  protobuf,
  bzip2,
  oniguruma,
  sqlite,
  xz,
  zlib,
  zstd,
  buildNpmPackage,
  gitUpdater,
}:

let
  version = "0.15.3";
  src = fetchFromGitHub {
    owner = "openobserve";
    repo = "openobserve";
    tag = "v${version}";
    hash = "sha256-GHyfIVUSX7evP3LaHZClD1RjZ6somYcMNBFdkaZL7lg=";
  };
  web = buildNpmPackage {
    inherit src version;
    pname = "openobserve-ui";

    sourceRoot = "${src.name}/web";

    npmDepsHash = "sha256-5bXEC48m3FbtmLwVYYvEdMV3qWA7KNEKVxkMZ94qEpA=";

    preBuild = ''
      # Patch vite config to not open the browser to visualize plugin composition
      substituteInPlace vite.config.ts \
        --replace "open: true" "open: false";
    '';

    env = {
      NODE_OPTIONS = "--max-old-space-size=8192";
      # cypress tries to download binaries otherwise
      CYPRESS_INSTALL_BINARY = 0;
    };

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share
      mv dist $out/share/openobserve-ui
      runHook postInstall
    '';
  };
in
rustPlatform.buildRustPackage {
  pname = "openobserve";
  inherit version src;

  patches = [
    # prevent using git to determine version info during build time
    ./build.rs.patch
  ];

  preBuild = ''
    cp -r ${web}/share/openobserve-ui web/dist
  '';

  cargoHash = "sha256-j/bx4qoWcSh2/yJ9evnzSfyUd0tLAk4M310A89k4wy8=";

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs = [
    bzip2
    oniguruma
    sqlite
    xz
    zlib
    zstd
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;

    RUSTC_BOOTSTRAP = 1; # uses experimental features

    # the patched build.rs file sets these variables
    GIT_VERSION = src.tag;
    GIT_COMMIT_HASH = "builtByNix";
    GIT_BUILD_DATE = "1970-01-01T00:00:00Z";
  };

  # requires network access or filesystem mutations
  checkFlags = [
    "--skip=handler::http::router::tests::test_get_proxy_routes"
    "--skip=tests::e2e_test"
    "--skip=tests::test_setup_logs"
    "--skip=handler::http::router::middlewares::compress::Compress"
    # Tests are not threadsafe. Most likely can only run one test at a time,
    # due to altering shared database state.
    # This option already in upstream code: https://github.com/openobserve/openobserve/pull/7084
    # Also see: https://github.com/NixOS/nixpkgs/pull/457421
    "--test-threads=1"
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
    ignoredVersions = "rc";
  };

  meta = {
    description = "Cloud-native observability platform built specifically for logs, metrics, traces, analytics & realtime user-monitoring";
    homepage = "https://github.com/openobserve/openobserve";
    changelog = "https://github.com/openobserve/openobserve/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
    mainProgram = "openobserve";
  };
}
