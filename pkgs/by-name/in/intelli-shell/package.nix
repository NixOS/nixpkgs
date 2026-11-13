{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  sqlite,
  zlib,
  aws-lc,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "intelli-shell";
  version = "3.4.8";

  src = fetchFromGitHub {
    owner = "lasantosr";
    repo = "intelli-shell";
    rev = "v${finalAttrs.version}";
    hash = "sha256-qCeNXobiI3KVZaRMWkEoVRBrk7Bjc+udp/ZDv+tGUMQ=";
  };

  cargoHash = "sha256-O0u+VF0flYGO2xw8oxfZYbeHFOB6MqiAoiBIlEneMpg=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "extra-features"
  ];

  buildInputs = [
    libgit2
    openssl
    sqlite
    zlib
    aws-lc
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  meta = {
    description = "Like IntelliSense, but for shells";
    homepage = "https://github.com/lasantosr/intelli-shell";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lasantosr ];
    mainProgram = "intelli-shell";
  };
})
