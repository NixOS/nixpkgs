{ clang
, fetchFromGitHub
, lib
, llvmPackages
, protobuf
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "polkadot";
  version = "0.8.24";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "polkadot";
    rev = "v${version}";
    sha256 = "15q5scajxrf82k8nxysah8cs3yl2p09xzzwlkxvjkcn08r3zhig6";
  };

  cargoSha256 = "0qp20g5c15qzp2n1nzwqbnn2wx6c905vh652nvkm7sb1d901iiqi";

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
    maintainers = with maintainers; [ akru andresilva ];
    platforms = platforms.linux;
  };
}
