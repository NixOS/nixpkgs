{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, cmake
, protobuf
, llvmPackages
, rocksdb
, Security
, DiskArbitration
, Foundation
}:

rustPlatform.buildRustPackage rec {
  pname = "iroh";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = "iroh";
    rev = "v${version}";
    sha256 = "sha256-hw9OTV+IE4TE3Ubtpw6HiUmapBYAKN33xgVA1siCgqM=";
  };

  cargoPatches = [
    ./Cargo.toml.patch
    ./Cargo.lock.patch
  ];
  cargoSha256 = "sha256-lTYv0oivEe892xu1v9nf8AzNUD7KQFkVGe61Hj7CtlQ=";

  nativeBuildInputs = [
    cmake
    protobuf
    llvmPackages.clang
  ];
  buildInputs = [
  ] ++ lib.optionals stdenv.isDarwin [
    Security
    DiskArbitration
    Foundation
  ];

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  # link rocksdb dynamically?
  ROCKSDB_INCLUDE_DIR = "${rocksdb}/include";
  ROCKSDB_LIB_DIR = "${rocksdb}/lib";

  postPatch = ''
    # git_version failing, due to building from tarball
    for file in \
      iroh-p2p/src/metrics.rs \
      iroh-bitswap/src/metrics.rs \
      iroh-store/src/metrics.rs \
      iroh-gateway/src/metrics.rs \
      iroh/src/metrics.rs
    do
      substituteInPlace $file \
        --replace 'git_version!()' '"${version}"' \
        --replace 'use git_version::git_version;' ""
    done
  '';

  checkFlags = [
    "--skip=node::tests::test_fetch_providers_"
    "--skip=resolver::tests::test_resolve_"
    "--skip=lock::test::test_locks"
  ];

  meta = with lib; {
    description = "The most efficient implementation of IPFS on any planet";
    homepage = "https://github.com/n0-computer/iroh";
    changelog = "https://github.com/n0-computer/iroh/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ _0x4A6F flokli ];
  };
}
