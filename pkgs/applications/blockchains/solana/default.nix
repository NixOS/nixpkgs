{ stdenv
, fetchFromGitHub
, lib
, rustPlatform
, IOKit
, Security
, AppKit
, pkg-config
, udev
, zlib
, protobuf
}:
rustPlatform.buildRustPackage rec {
  pname = "solana-testnet-cli";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "solana-labs";
    repo = "solana";
    rev = "v${version}";
    sha256 = "sha256-wrv35vBohLztMZPb6gfZdCaXcjj/Y7vnQqINaI6dBM4=";
  };

  cargoSha256 = "sha256-A5uVa+cRmrkVyw7MFH4QAr0VIFi18wcc2VPFvQyT9EM=";

  buildAndTestSubdir = "cli";

  nativeBuildInputs = lib.optionals stdenv.isLinux [ protobuf pkg-config ];
  buildInputs = lib.optionals stdenv.isLinux [ udev zlib ] ++ lib.optionals stdenv.isDarwin [ IOKit Security AppKit ];

  # check phase fails
  # on darwin with missing framework System. This framework is not available in nixpkgs
  # on linux with some librocksdb-sys compilation error
  doCheck = false;

  # all the following are needed for the checkphase
  # checkInputs = lib.optionals stdenv.isDarwin [ pkg-config rustfmt ];
  # Needed to get openssl-sys to use pkg-config.
  # OPENSSL_NO_VENDOR = 1;
  # OPENSSL_LIB_DIR = "${openssl.out}/lib";
  # OPENSSL_DIR="${lib.getDev openssl}";
  # LLVM_CONFIG_PATH="${llvm}/bin/llvm-config";
  # LIBCLANG_PATH="${llvmPackages.libclang.lib}/lib";
  # Used by build.rs in the rocksdb-sys crate. If we don't set these, it would
  # try to build RocksDB from source.
  # ROCKSDB_INCLUDE_DIR="${rocksdb}/include";
  # ROCKSDB_LIB_DIR="${rocksdb}/lib";

  meta = with lib; {
    description = "Web-Scale Blockchain for fast, secure, scalable, decentralized apps and marketplaces. ";
    homepage = "https://solana.com";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
    platforms = platforms.unix;
  };
}
