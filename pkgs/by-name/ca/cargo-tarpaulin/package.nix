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
  version = "0.32.5";

  src = fetchFromGitHub {
    owner = "xd009642";
    repo = "tarpaulin";
    rev = version;
    hash = "sha256-68WDe0Fp0QJ6WCVJFeMniJTpGSzfxLGLM/a/CZxVxrA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Uf+l4LqPoG8FKvZD0lYGC2hz7gLZYJf6HAUe0SQiT9s=";

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs =
    [ openssl ]
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
