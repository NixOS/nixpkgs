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
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "kdash-rs";
    repo = "kdash";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-fFpdWVoeWycnp/hRw2S+hYpnXYmCs+rLqcZdmSSMGwI=";
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

  cargoHash = "sha256-72DuM64wj8WW6soagodOFIeHvVn1CPpb1T3Y7GQYsbs=";

  meta = {
    description = "Simple and fast dashboard for Kubernetes";
    mainProgram = "kdash";
    homepage = "https://github.com/kdash-rs/kdash";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ matthiasbeyer ];
  };
})
