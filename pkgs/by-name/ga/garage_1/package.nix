{
  lib,
  rustPlatform,
  fetchFromGitea,
  libsodium,
  pkg-config,
  protobuf,
  sqlite,
  zstd,
  cacert,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "garage";
  version = "1.3.1";

  src = fetchFromGitea {
    domain = "git.deuxfleurs.fr";
    owner = "Deuxfleurs";
    repo = "garage";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wkCnJmbulnhzwHvzdpzh9MRceOzmPdhOogffwhqNGPg=";
  };

  cargoHash = "sha256-jfYe2A6zkVgTLrWBDbahICSKCRO3FwsBPNSVFapH0Rs=";

  nativeBuildInputs = [
    protobuf
    pkg-config
  ];

  buildInputs = [
    libsodium
    sqlite
    zstd
  ];

  checkInputs = [
    cacert
  ];

  __darwinAllowLocalNetworking = true;

  env = {
    SODIUM_USE_PKG_CONFIG = true;
    LIBSQLITE3_SYS_USE_PKG_CONFIG = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "system-libs"
    "consul-discovery"
    "fjall"
    "journald"
    "k2v"
    "kubernetes-discovery"
    "lmdb"
    "metrics"
    "sqlite"
    "syslog"
    "telemetry-otlp"
  ];

  meta = {
    description = "S3-compatible object store for small self-hosted geo-distributed deployments";
    changelog = "https://git.deuxfleurs.fr/Deuxfleurs/garage/releases/tag/v${finalAttrs.version}";
    homepage = "https://garagehq.deuxfleurs.fr";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      nickcao
      _0x4A6F
      teutat3s
      herbetom
      anish
    ];
    knownVulnerabilities = [ "Garage version ${finalAttrs.version} is EOL" ];
    mainProgram = "garage";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
