{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  curl,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tarpaulin";
  version = "0.33.0";

  src = fetchFromGitHub {
    owner = "xd009642";
    repo = "tarpaulin";
    tag = version;
    hash = "sha256-yCuyeBL/7Dh9+V7fWvKkmj9OLGh88Jre7o0+TQXem9U=";
  };

  cargoHash = "sha256-S3cIcw6ZDAn8DVbCM7T5t7R3t45iGuh5600KeKQNXS8=";

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    curl
  ];

  doCheck = false;

  meta = with lib; {
    description = "Code coverage tool for Rust projects";
    mainProgram = "cargo-tarpaulin";
    homepage = "https://github.com/xd009642/tarpaulin";
    changelog = "https://github.com/xd009642/tarpaulin/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [
      figsoda
      hugoreeves
    ];
  };
}
