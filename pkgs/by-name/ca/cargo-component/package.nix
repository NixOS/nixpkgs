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
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "cargo-component";
    rev = "v${version}";
    hash = "sha256-pW3hhcsMzKSWmUX8HwAtZCB+v9B4qXw6WUGODhPtW+Q=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Vnef3ApklZtN417dXhA+YWcsAeSTDSt6wA+7SjBKHm0=";

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
