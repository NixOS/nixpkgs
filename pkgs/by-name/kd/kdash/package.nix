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
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "kdash-rs";
    repo = "kdash";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-1ZG0u4k95tm+k/cvLIzWD/pvVrdP3+ivTqtKr3Pniqw=";
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

  cargoHash = "sha256-zcvlR7BDkeTcwhGi2Fyz2VdfZH4+JOMRTIjIXkTAHOU=";

  meta = {
    description = "Simple and fast dashboard for Kubernetes";
    mainProgram = "kdash";
    homepage = "https://github.com/kdash-rs/kdash";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ matthiasbeyer ];
  };
})
