{
  lib,
  fetchFromGitHub,
  libpq,
  openssl,
  pkg-config,
  rustPlatform,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kepler";
  version = "1.0.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Exein-io";
    repo = "kepler";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oRcd9VpusHFfLulNTsjrb9+cMUwRCFmF8i50+HNBZSc=";
  };

  cargoHash = "sha256-waV73sR/M6WMkl6GaQGW1ZEIIiiFo3S+rLY2ykmY40Q=";

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

  meta = {
    description = "NIST-based CVE lookup store and API powered by Rust";
    homepage = "https://github.com/Exein-io/kepler";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "kepler";
  };
})
