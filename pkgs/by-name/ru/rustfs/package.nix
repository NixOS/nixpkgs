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
  cacert,
  nixosTests,
}:

let
  console = stdenv.mkDerivation (finalAttrs: {
    pname = "rustfs-console";
    version = "0.1.13";
    __structuredAttrs = true;
    __darwinAllowLocalNetworking = true;

    src = fetchFromGitHub {
      owner = "rustfs";
      repo = "console";
      tag = "v${finalAttrs.version}";
      hash = "sha256-pxpT3kV30qA+Ob/RWi11rsapGyNc6h1EN79fcPi1e1E=";
    };

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      fetcherVersion = 4;
      hash = "sha256-+U4HRaThEeC6jA6dA4UmhJLvANq0IMySOW5ua9m5Q6A=";
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
  version = "1.0.0-beta.9";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rustfs";
    repo = "rustfs";
    tag = version;
    hash = "sha256-aNbicnNHaJn05k5EffgPEURf/Uj2A8PjOHiH2UGPz4M=";
  };

  postPatch = ''
    rm -rf ./rustfs/static
    cp -rL ${console} ./rustfs/static
  '';

  cargoHash = "sha256-abbsElP4dSSZnL4UfQEoHUtiEW8B/p6Y81UA7EbqbD4=";

  nativeBuildInputs = [
    protobuf
    cacert
  ];

  env = {
    RUSTFLAGS = "--cfg tokio_unstable";
    # reqwest loads CA certs even if not used during tests
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  };

  # Only build the main rustfs binary
  cargoBuildFlags = "-p rustfs";
  cargoTestFlags = "-p rustfs";

  checkFlags = [
    # failing since 1.0.0-beta.9, seem like upstream issues
    "--skip=app::capacity_dirty_scope_test"
    "--skip=app::delete_objects_stat_gating_test"
    "--skip=app::put_prelookup_gating_test"
    "--skip=two_embedded_servers_isolate_auth_and_data_planes"
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
