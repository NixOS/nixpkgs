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

rustPlatform.buildRustPackage rec {
  pname = "habitat";
  version = "2.0.60";

  src = fetchFromGitHub {
    owner = "habitat-sh";
    repo = "habitat";
    rev = version;
    hash = "sha256-IeHDYGnuugb1Ki02qqN9EFaCxgCb6SeQR/zPEwqfRLw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-K2WQl7KnAKwHL39Uw+T9WRlE/dtAeyndQO2uiDXsu04=";

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
  cargoTestFlags = cargoBuildFlags;

  env = {
    OPENSSL_NO_VENDOR = true;
    SODIUM_USE_PKG_CONFIG = true;
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  };

  meta = with lib; {
    description = "Application automation framework";
    homepage = "https://www.habitat.sh";
    changelog = "https://github.com/habitat-sh/habitat/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [
      rushmorem
      qjoly
    ];
    mainProgram = "hab";
    platforms = [ "x86_64-linux" ];
  };
}
