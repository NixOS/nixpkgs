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
  version = "0.34.1";

  src = fetchFromGitHub {
    owner = "xd009642";
    repo = "tarpaulin";
    tag = version;
    hash = "sha256-HJgcFQrHINm4BPfZ4c5ZHQYBTSBVYdSl/n0qBlSsNOI=";
  };

  cargoHash = "sha256-/IIO462dN1v7r05uDGo+QbH8gkSGa93StjLleP/KUPw=";

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
      hugoreeves
    ];
  };
}
