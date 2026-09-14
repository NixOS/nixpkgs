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
    version = "0.1.25";
    __structuredAttrs = true;
    __darwinAllowLocalNetworking = true;

    src = fetchFromGitHub {
      owner = "rustfs";
      repo = "console";
      tag = "v${finalAttrs.version}";
      hash = "sha256-wPxexsOaZD+pmf1XldN8baa1f6tE0xj/B706m5uwlwc=";
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
  version = "1.0.0-rc.5";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rustfs";
    repo = "rustfs";
    tag = finalAttrs.version;
    hash = "sha256-Xb9Lv+8BvHF089D5YwTp7DOMosXc8bUYYEV5F7V2gxU=";
  };

  postPatch = ''
    rm -rf ./rustfs/static
    cp -rL ${finalAttrs.console} ./rustfs/static

    substituteInPlace Cargo.toml --replace-fail "1.98.0" "1.97.0"
  '';

  cargoHash = "sha256-+PnEy6Z/ynNjgsgQz98Q/kGuyQ2+FgnJbh6Mk1/tohg=";

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

  useNextest = true;
  cargoTestFlags = [
    "--package"
    "rustfs"
    "--no-fail-fast"

    "--filterset"
    "not (test(connect::) or binary(connect_*) or test(=version::tests::test_is_head_newer_than_tag_requires_strict_descendant))"
  ];

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
