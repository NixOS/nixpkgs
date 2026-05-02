{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  protobuf,
  libsodium,
  openssl,
  xz,
  zeromq,
  cacert,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "habitat";
  version = "2.0.504";

  src = fetchFromGitHub {
    owner = "habitat-sh";
    repo = "habitat";
    rev = finalAttrs.version;
    hash = "sha256-9vdFT/gdN+4AaMz8txdGSwiDkEVx3XglGPpSB2Gn3Iw=";
  };

  cargoHash = "sha256-LZC32h3EKnzUhBIhqoxPzLLPJ7oMWDknMNfiUxDHvT4=";

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs = [
    libsodium
    openssl
    xz
    zeromq
  ];

  cargoBuildFlags = [
    "-p"
    "hab"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  env = {
    OPENSSL_NO_VENDOR = true;
    SODIUM_USE_PKG_CONFIG = true;
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  };

  meta = {
    description = "Application automation framework";
    homepage = "https://www.habitat.sh";
    changelog = "https://github.com/habitat-sh/habitat/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      rushmorem
      qjoly
    ];
    mainProgram = "hab";
    platforms = [ "x86_64-linux" ];
  };
})
