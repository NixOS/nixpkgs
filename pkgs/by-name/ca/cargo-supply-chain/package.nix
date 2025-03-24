{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-supply-chain";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "rust-secure-code";
    repo = "cargo-supply-chain";
    rev = "v${version}";
    hash = "sha256-KjeYB9TFbuJ2KPaObeM0ADs5F8uJJ6/czMPQjBUgIk8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-fsW3qTyFMcj/OTouOah1ZFskw075V8jBwhs02AxY7kU=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "Gather author, contributor and publisher data on crates in your dependency graph";
    mainProgram = "cargo-supply-chain";
    homepage = "https://github.com/rust-secure-code/cargo-supply-chain";
    changelog = "https://github.com/rust-secure-code/cargo-supply-chain/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [
      asl20
      mit
      zlib
    ]; # any of three
    maintainers = with maintainers; [
      figsoda
      matthiasbeyer
    ];
  };
}
