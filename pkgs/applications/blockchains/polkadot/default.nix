{ clang
, fetchFromGitHub
, lib
, llvmPackages
, protobuf
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "polkadot";
  version = "0.8.26-1";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "polkadot";
    rev = "v${version}";
    sha256 = "17ji1gjrx3gzw4msaz9kgvm132y14wgh8z183l3mfw1cj44a6kqk";
  };

  cargoSha256 = "07zwlwx02xw1y20br2c4grwv7bprhynqy7gav4qh3vw117ijpiqk";

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
