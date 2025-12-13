{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpm,
  pnpmConfigHook,
  nodejs,
  rustPlatform,
  protobuf,
  nixosTests,
}:

let
  console = stdenv.mkDerivation (finalAttrs: {
    pname = "rustfs-console";
    version = "0.1.7";
    __structuredAttrs = true;
    __darwinAllowLocalNetworking = true;

    src = fetchFromGitHub {
      owner = "rustfs";
      repo = "console";
      tag = "v${finalAttrs.version}";
      hash = "sha256-CBlfNNA4e2zXDCipMvLGWCH+DIH0JUjc+/mp3yjb16I=";
    };

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      fetcherVersion = 4;
      hash = "sha256-OT6NLDWMYOfV+pPvJkRw1que2fxSZhDuVQrcmyUXr60=";
    };

    nativeBuildInputs = [
      nodejs
      pnpm
      pnpmConfigHook
    ];

    buildPhase = ''
      pnpm run build
    '';

    installPhase = ''
      runHook preInstall
      cp -r out/. $out/
      runHook postInstall
    '';
  });
in
rustPlatform.buildRustPackage rec {
  pname = "rustfs";
  version = "1.0.0-beta.6";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rustfs";
    repo = "rustfs";
    tag = version;
    hash = "sha256-VfR6kRorrFOTYE+fCgBKwZM1JPJI/oUwuGj2LIBGHgc=";
  };

  postPatch = ''
    rm -rf ./rustfs/static
    cp -rL ${console} ./rustfs/static
  '';

  cargoHash = "sha256-6KMPCKmGKU49iVGBNb/Ra+Ta2OlWHjvGH8LmskiHfM8=";

  nativeBuildInputs = [
    protobuf
  ];

  env.RUSTFLAGS = "--cfg tokio_unstable";

  # Only build the main rustfs binary
  cargoBuildFlags = "-p rustfs";
  cargoTestFlags = "-p rustfs";

  checkFlags = [
    # assertion failed
    "--skip=storage::concurrent_get_object_test::tests::test_concurrent_request_tracking"
    # throws errors
    "--skip=admin::handlers::site_replication::tests::test_site_replication_peer_client_cache_hit_returns_cached_ready_client"
    "--skip=admin::handlers::site_replication::tests::test_site_replication_peer_client_rebuilds_when_generation_changes"
  ];

  passthru.tests = {
    inherit (nixosTests) rustfs;
  };

  meta = {
    description = "S3-compatible high-performance object storage system supporting migration and coexistence with other S3-compatible platforms such as MinIO and Ceph";
    homepage = "https://github.com/rustfs/rustfs";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ marcel ];
    mainProgram = "rustfs";
  };
}
