{
  lib,
  stdenv,
  rustPlatform,
  python3,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "rust-synapse-compress-state";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "rust-synapse-compress-state";
    rev = "v${version}";
    hash = "sha256-nNQ/d4FFAvI+UY+XeqExyhngq+k+j5Pkz94ch27aoVM=";
  };

  cargoHash = "sha256-l8N6+xh0CbFKt4eEbSAvUJ5oHxhp5jf2YHLheYAegnU=";

  cargoBuildFlags = [
    "--all"
  ];

  # Needed to get openssl-sys to use pkgconfig.
  env.OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [
    python3
    pkg-config
  ];

  buildInputs = [ openssl ];

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Tool to compress some state in a Synapse instance's database";
    homepage = "https://github.com/matrix-org/rust-synapse-compress-state";
    license = licenses.asl20;
    maintainers = with maintainers; [
      hexa
      maralorn
    ];
  };
}
