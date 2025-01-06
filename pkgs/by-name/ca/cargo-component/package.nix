{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-component";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "cargo-component";
    rev = "v${version}";
    hash = "sha256-HiDwFWEzzCmwlEKsVmKREtn5OfAziC+irgeh66fRWIQ=";
  };

  cargoHash = "sha256-AtOZGYH0ya5mza3QFTfaXvw9tcFDGuz72JUhfTdUml8=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  # requires the wasm32-wasi target
  doCheck = false;

  meta = with lib; {
    description = "Cargo subcommand for creating WebAssembly components based on the component model proposal";
    homepage = "https://github.com/bytecodealliance/cargo-component";
    changelog = "https://github.com/bytecodealliance/cargo-component/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "cargo-component";
  };
}
