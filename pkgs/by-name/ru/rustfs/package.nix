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
  nix-update,
  nixosTests,
  writeShellApplication,
}:

let
  console = stdenv.mkDerivation (finalAttrs: {
    pname = "rustfs-console";
    version = "0.1.24";
    __structuredAttrs = true;
    __darwinAllowLocalNetworking = true;

    src = fetchFromGitHub {
      owner = "rustfs";
      repo = "console";
      tag = "v${finalAttrs.version}";
      hash = "sha256-lwpPig2xp9mTgl4odgcrTXohtGGvWMTbkup2KN9RPpE=";
    };

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      fetcherVersion = 4;
      hash = "sha256-wfaUMWTa8eFkzY/wCD5o7+G2OiSTWCqm+py3sgqDI04=";
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
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustfs";
  version = "1.0.0-rc.4";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rustfs";
    repo = "rustfs";
    tag = finalAttrs.version;
    hash = "sha256-XF7YrmVCPmJnRTA0KzwIbnhc6ENmr51Z0LMlzJZ5JmM=";
  };

  postPatch = ''
    rm -rf ./rustfs/static
    cp -rL ${finalAttrs.console} ./rustfs/static
  '';

  cargoHash = "sha256-mmOINLCioI6QvVY+osKukCtYdLkNq6QtJHCQp0o/CQ4=";

  nativeBuildInputs = [
    protobuf
    cacert
  ];

  inherit console;

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

  passthru = {
    tests = {
      inherit (nixosTests) rustfs;
    };

    updateScript = lib.getExe (writeShellApplication {
      name = "rustfs-update-script";
      runtimeInputs = [ nix-update ];
      text = ''
        nix-update rustfs
        nix-update rustfs.console
      '';
    });
  };

  meta = {
    description = "S3-compatible high-performance object storage system supporting migration and coexistence with other S3-compatible platforms such as MinIO and Ceph";
    homepage = "https://github.com/rustfs/rustfs";
    changelog = "https://github.com/rustfs/rustfs/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ marcel ];
    mainProgram = "rustfs";
  };
})
