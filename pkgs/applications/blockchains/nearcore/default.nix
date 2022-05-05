{ rustPlatform, lib, fetchFromGitHub
, zlib, elfutils, openssl
, cmake, python3, pkg-config, protobuf, perl, llvmPackages
}:
rustPlatform.buildRustPackage rec {
  #https://github.com/near/nearcore
  pname = "nearcore";
  version = "1.25.0";
  src = fetchFromGitHub {
    owner = "near";
    repo = "nearcore";
    # there is also a branch for this version number, so we need to be explicit
    rev = "refs/tags/${version}";
    sha256 = "sha256-7hiBqJLGIf+kNKJvMQ7KtGZm/SWLY3pT7YDlwbm3HDM=";
  };

  cargoSha256 = "sha256-EGv4CibSHL9oTAdWK7d/SOzZWPcEB16hTWlWHjKU4wc=";

  # don't build SDK samples that require wasm-enabled rust
  cargoBuildFlags = [ "-p" "neard" ];
  doCheck = false; # needs network

  buildInputs = [ zlib elfutils openssl ];
  nativeBuildInputs = [
    cmake
    python3
    pkg-config
    protobuf
    perl
  ];

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
  BINDGEN_EXTRA_CLANG_ARGS = "-isystem ${llvmPackages.libclang.lib}/lib/clang/${lib.getVersion llvmPackages.clang}/include";

  meta = with lib; {
    description = "Reference client for NEAR Protocol";
    homepage = "https://github.com/near/nearcore";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.unix;
  };
}
