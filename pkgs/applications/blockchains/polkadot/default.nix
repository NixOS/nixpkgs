{ clang
, fetchFromGitHub
, lib
, llvmPackages
, protobuf
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "polkadot";
  version = "0.8.26";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "polkadot";
    rev = "v${version}";
    sha256 = "1bvma6k3gsjqh8w76k4kf52sjg8wxn1b7a409kmnmmvmd9j6z5ia";
  };

  cargoSha256 = "0pacmmvvjgzmaxgg47qbfhqwl02jxj3i6vnmkjbj9npzqfmqf72d";

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
