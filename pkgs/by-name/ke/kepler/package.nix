{
  lib,
  fetchFromGitHub,
  libpq,
  openssl,
  pkg-config,
  rustPlatform,
  zstd,
}:

rustPlatform.buildRustPackage {
  pname = "kepler";
  version = "unstable-2023-07-19";

  src = fetchFromGitHub {
    owner = "Exein-io";
    repo = "kepler";
    rev = "9f4f9c617f2477850ed70f1b1d7387807c35d26c";
    hash = "sha256-jmQ88flSMrS0CB7GNj1Ee60HZgroDKTwLk0i/kg6gVM=";
  };

  cargoHash = "sha256-5ORjyzCkX3j62pL4S8CqSXExZUjTIO0db99oIuczEY0=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libpq
    openssl
    zstd
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = with lib; {
    description = "NIST-based CVE lookup store and API powered by Rust";
    homepage = "https://github.com/Exein-io/kepler";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "kepler";
  };
}
