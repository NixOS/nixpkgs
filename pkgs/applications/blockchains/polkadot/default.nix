{ clang
, fetchFromGitHub
, lib
, llvmPackages
, protobuf
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "polkadot";
  version = "0.8.25";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "polkadot";
    rev = "v${version}";
    sha256 = "1jdklmysr25rlwgx7pz0jw66j1w60h98kqghzjhr90zhynzh39lz";
  };

  cargoSha256 = "08yfafrspkd1g1mhlfwngbknkxjkyymbcga8n2rdsk7mz0hm0vgy";

  cargoPatches = [ ./substrate-wasm-builder-runner.patch ];

  nativeBuildInputs = [ clang ];

  LIBCLANG_PATH = "${llvmPackages.libclang}/lib";
  PROTOC = "${protobuf}/bin/protoc";

  # NOTE: We don't build the WASM runtimes since this would require a more
  # complicated rust environment setup. The resulting binary is still useful for
  # live networks since those just use the WASM blob from the network chainspec.
  BUILD_DUMMY_WASM_BINARY = 1;

  # We can't run the test suite since we didn't compile the WASM runtimes.
  doCheck = false;

  meta = with lib; {
    description = "Polkadot Node Implementation";
    homepage = "https://polkadot.network";
    license = licenses.gpl3;
    maintainers = with maintainers; [ akru andresilva RaghavSood ];
    platforms = platforms.linux;
  };
}
