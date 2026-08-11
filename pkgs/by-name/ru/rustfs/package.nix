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
    version = "0.1.17";
    __structuredAttrs = true;
    __darwinAllowLocalNetworking = true;

    src = fetchFromGitHub {
      owner = "rustfs";
      repo = "console";
      tag = "v${finalAttrs.version}";
      hash = "sha256-t1NYCSdhCYSRjQ/qp+lFP43/N9UXapGiLN7a0gcUaYU=";
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
  version = "1.0.0-beta.12";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rustfs";
    repo = "rustfs";
    tag = version;
    hash = "sha256-u5DhPg0e42IvP5lNyLVh2kBQLEYQz3J5crnTs8mfFms=";
  };

  postPatch = ''
    rm -rf ./rustfs/static
    cp -rL ${console} ./rustfs/static
  '';

  cargoHash = "sha256-5QpSWlGN0zV6BW6joRyP+Ly6QEVTkHTJUSBBnyYx+EQ=";

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

  # tests share global state and fail depending on execution order,
  # upstream uses nexttest to run tests in separate processes
  useNextest = true;

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
