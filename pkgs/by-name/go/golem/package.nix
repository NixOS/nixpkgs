{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  stdenv,
  darwin,
  protobuf,
  redis,
  fontconfig,
}:
rustPlatform.buildRustPackage rec {
  pname = "golem";
  version = "1.0.16";

  src = fetchFromGitHub {
    owner = "golemcloud";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-XfSy6MGkEuEAhrF9LQJvHM786fFrBhYNJ4cIX+1eCvo=";
  };

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];
  buildInputs =
    [
      fontconfig
      openssl.dev
    ]
    ++ lib.optionals stdenv.isDarwin [
      #darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  # Tests are failing in the sandbox because of some redis integration tests
  doCheck = false;
  checkInputs = [ redis ];

  # Required for golem-wasm-rpc's build.rs to find the required protobuf files
  # https://github.com/golemcloud/wasm-rpc/blob/v1.0.3/wasm-rpc/build.rs#L7
  GOLEM_WASM_AST_ROOT = "/build/cargo-vendor-dir/golem-wasm-ast-1.0.0";
  # Required for golem-examples's build.rs to find the required Wasm Interface Type (WIT) files
  # https://github.com/golemcloud/golem-examples/blob/v1.0.6/build.rs#L9
  GOLEM_WIT_ROOT = "/build/cargo-vendor-dir/golem-wit-1.0.0";

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "cranelift-bforest-0.108.1" = "sha256-WVRj6J7yXLFOsud9qKugmYja0Pe7AqZ0O2jgkOtHRg8=";
      "libtest-mimic-0.7.0" = "sha256-xUAyZbti96ky6TFtUjyT6Jx1g0N1gkDPjCMcto5SzxE=";
    };
  };

  meta = with lib; {
    description = "Golem is an open source durable computing platform that makes it easy to build and deploy highly reliable distributed systems.";
    homepage = "https://www.golem.cloud/";
    license = licenses.asl20;
    mainProgram = "golem-cli";
  };
}
