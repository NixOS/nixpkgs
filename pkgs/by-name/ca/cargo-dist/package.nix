{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  aws-lc,
  bzip2,
  xz,
  zstd,
  git,
  rustup,
  cacert,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-dist";
  version = "0.34.0";

  src = fetchFromGitHub {
    owner = "axodotdev";
    repo = "cargo-dist";
    tag = "v${finalAttrs.version}";
    hash = "sha256-u0Ux0V6Jdeq/1uwSu9+8sm/KGAg3RbWQph/UdL2IMZU=";
  };

  cargoHash = "sha256-sOLAyXEOGGnKNeEtPbjYjuJK/d71nluj2MsHNIuuLvQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    aws-lc
    bzip2
    xz
    zstd
  ];

  nativeCheckInputs = [
    git
    rustup
    cacert
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  };

  # remove tests that require internet access
  postPatch = ''
    rm cargo-dist/tests/cli-tests.rs cargo-dist/tests/integration-tests.rs
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for building final distributable artifacts and uploading them to an archive";
    mainProgram = "dist";
    homepage = "https://github.com/axodotdev/cargo-dist";
    changelog = "https://github.com/axodotdev/cargo-dist/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      matthiasbeyer
      mistydemeo
    ];
  };
})
