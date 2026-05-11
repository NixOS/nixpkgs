{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchurl,
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

rustPlatform.buildRustPackage (
  finalAttrs:
  let
    web = buildNpmPackage {
      inherit (finalAttrs) src version;
      pname = "openobserve-ui";

      sourceRoot = "${finalAttrs.src.name}/web";

      npmDepsHash = "sha256-UNdFqUJI/pdHJjjA5Aebnvq1T7oITJ1R96rEQOBxTug=";

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
  {
    pname = "openobserve";
    version = "0.50.3";

    src = fetchFromGitHub {
      owner = "openobserve";
      repo = "openobserve";
      tag = "v${finalAttrs.version}";
      hash = "sha256-eL1Qvl6M8idBHXSNHHQsTsu6g/CbTOt8NUTTaNZuB8M=";
    };

    patches = [
      # prevent using git to determine version info during build time
      ./build.rs.patch
    ];

    preBuild = ''
      cp -r ${web}/share/openobserve-ui web/dist
    '';

    cargoHash = "sha256-d67ZeAth0Q8h8xXJZl+2Z2/+M54Ef4xFlsPT9CnrwK4=";

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
      GIT_VERSION = finalAttrs.src.tag;
      GIT_COMMIT_HASH = "builtByNix";
      GIT_BUILD_DATE = "1970-01-01T00:00:00Z";

      RUSTFLAGS = "-C target-feature=+aes,+sse2";

      SWAGGER_UI_DOWNLOAD_URL =
        # When updating:
        # - Look for the version of `utoipa-swagger-ui` at:
        #   https://github.com/StractOrg/stract/blob/<STRACT-REV>/Cargo.toml#L183
        # - Look at the corresponding version of `swagger-ui` at:
        #   https://github.com/juhaku/utoipa/blob/utoipa-swagger-ui-<UTOPIA-SWAGGER-UI-VERSION>/utoipa-swagger-ui/build.rs#L21-L22
        let
          swaggerUiVersion = "5.17.14";
          swaggerUi = fetchurl {
            url = "https://github.com/swagger-api/swagger-ui/archive/refs/tags/v${swaggerUiVersion}.zip";
            hash = "sha256-SBJE0IEgl7Efuu73n3HZQrFxYX+cn5UU5jrL4T5xzNw=";
          };
        in
        "file://${swaggerUi}";
    };

    # swagger-ui will once more be copied in the target directory during the check phase
    # Not deleting the existing unpacked archive leads to a `PermissionDenied` error
    preCheck = ''
      rm -rf target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/build/
    '';

    # Skip doctests: upstream release build for v0.50.3 runs cargo build only,
    # and the doctest examples currently fail due to async context.
    cargoTestFlags = [
      "--lib"
      "--bins"
      "--tests"
      "--examples"
    ];

    # requires network access or filesystem mutations
    checkFlags = [
      "--skip=handler::http::router::tests::test_get_proxy_routes"
      "--skip=tests::e2e_test"
      "--skip=tests::test_setup_logs"
      "--skip=handler::http::router::middlewares::compress::Compress"
      "--skip=service::github"
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
      changelog = "https://github.com/openobserve/openobserve/releases/tag/v${finalAttrs.version}";
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [ happysalada ];
      mainProgram = "openobserve";
    };
  }
)
