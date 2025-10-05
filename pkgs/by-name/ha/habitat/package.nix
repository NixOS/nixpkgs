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
  version = "1.6.1245";

  src = fetchFromGitHub {
    owner = "habitat-sh";
    repo = "habitat";
    rev = version;
    hash = "sha256-n2ylJSCXPnnPHadfZaRS/3vxtnvkXhiTzCyObK7hmEk=";
  };

  cargoHash = "sha256-JMIAHupv3da71j5ID5ZR0mD7ZLLj4ktIs0aQrdWi3jU=";

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
