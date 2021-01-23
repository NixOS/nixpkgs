{ clang
, fetchFromGitHub
, lib
, llvmPackages
, protobuf
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "polkadot";
  version = "0.8.27";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "polkadot";
    rev = "v${version}";
    sha256 = "1zkqmsclhnv14s4mxz7h49kfx8wyi3lyi0dik6jn1fh6w8zr962c";
  };

  cargoSha256 = "1j0pr09y5pc43a4rz1zq3h9vmd874zz6z0wd279lpm6p2m0077cs";

  nativeBuildInputs = [ clang ];

  LIBCLANG_PATH = "${llvmPackages.libclang}/lib";
  PROTOC = "${protobuf}/bin/protoc";

  # NOTE: We don't build the WASM runtimes since this would require a more
  # complicated rust environment setup and this is only needed for developer
  # environments. The resulting binary is useful for end-users of live networks
  # since those just use the WASM blob from the network chainspec.
  SKIP_WASM_BUILD = 1;

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
