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
  tzdata,
  nixosTests,
}:

let
  console = stdenv.mkDerivation (finalAttrs: {
    pname = "rustfs-console";
    version = "0.1.20";
    __structuredAttrs = true;
    __darwinAllowLocalNetworking = true;

    src = fetchFromGitHub {
      owner = "rustfs";
      repo = "console";
      tag = "v${finalAttrs.version}";
      hash = "sha256-EUyjYPDkHmD8RRmusFnWsWiKbRRSzZ0c4pbMr+2PJdE=";
    };

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      fetcherVersion = 4;
      hash = "sha256-ox4hKm3f4QVpxfx4g0uNDRY7w6O3L3AVz2nmHhs8UHM=";
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
  version = "1.0.0-rc.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rustfs";
    repo = "rustfs";
    tag = version;
    hash = "sha256-iVAIsq/SAabdBjnNYLF7oQRagUILRN5HEUumnVqp1CM=";
  };

  postPatch = ''
    rm -rf ./rustfs/static
    cp -rL ${console} ./rustfs/static
  '';

  cargoHash = "sha256-W6+6Ypw9WTbprQbDVbhdvB+hEW71oPOHYQV5bZKtJhc=";

  nativeBuildInputs = [
    protobuf
    cacert
  ];

  env = {
    RUSTFLAGS = "--cfg tokio_unstable";
    # reqwest loads CA certs even if not used during tests
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
    # jiff needs a time zone database to resolve zones like UTC during tests
    TZDIR = "${tzdata}/share/zoneinfo";
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
