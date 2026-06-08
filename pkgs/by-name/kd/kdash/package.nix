{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  perl,
  python3,
  openssl,
  libxcb-util,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kdash";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "kdash-rs";
    repo = "kdash";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-xc2vNPQWg6P+FWxKekvOTW3QHxgmkD6t/jgYGdoaMeI=";
  };

  nativeBuildInputs = [
    perl
    python3
    pkg-config
  ];

  buildInputs = [
    openssl
    libxcb-util
  ];

  # Fix for build failure with gcc15
  env.NIX_CFLAGS_COMPILE = "-std=gnu17";

  cargoHash = "sha256-aEVV5E0GvskhSRwwPD8at4xwkn2Q6k5SO1fyFrsDbFM=";

  meta = {
    description = "Simple and fast dashboard for Kubernetes";
    mainProgram = "kdash";
    homepage = "https://github.com/kdash-rs/kdash";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ matthiasbeyer ];
  };
})
