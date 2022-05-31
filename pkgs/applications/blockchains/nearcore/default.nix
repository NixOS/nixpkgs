{ rustPlatform, lib, fetchFromGitHub
, zlib, openssl
, pkg-config, protobuf, llvmPackages
}:
rustPlatform.buildRustPackage rec {
  pname = "nearcore";
  version = "1.26.1";

  # https://github.com/near/nearcore/tags
  src = fetchFromGitHub {
    owner = "near";
    repo = "nearcore";
    # there is also a branch for this version number, so we need to be explicit
    rev = "refs/tags/${version}";
    sha256 = "sha256-WoQtDdbFcvl6Wp5uv2tr/W/YYH8dyezF+LzSJ5oJcYY=";
  };

  cargoSha256 = "sha256-7h14XzhhPmkPoTx0kkJl7I7CPqbRAtxa1zpplYxg4p4=";

  postPatch = ''
    substituteInPlace neard/build.rs \
      --replace 'get_git_version()?' '"nix:${version}"'
  '';

  CARGO_PROFILE_RELEASE_CODEGEN_UNITS = "1";
  CARGO_PROFILE_RELEASE_LTO = "fat";
  NEAR_RELEASE_BUILD = "release";

  OPENSSL_NO_VENDOR = 1; # we want to link to OpenSSL provided by Nix

  # don't build SDK samples that require wasm-enabled rust
  buildAndTestSubdir = "neard";
  doCheck = false; # needs network

  buildInputs = [
    zlib
    openssl
  ];

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  # fat LTO requires ~3.4GB RAM
  requiredSystemFeatures = [ "big-parallel" ];

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
  BINDGEN_EXTRA_CLANG_ARGS = "-isystem ${llvmPackages.libclang.lib}/lib/clang/${lib.getVersion llvmPackages.clang}/include";

  meta = with lib; {
    description = "Reference client for NEAR Protocol";
    homepage = "https://github.com/near/nearcore";
    license = licenses.gpl3;
    maintainers = with maintainers; [ mic92 mikroskeem ];
    # only x86_64 is supported in nearcore because of sse4+ support, macOS might
    # be also possible
    platforms = [ "x86_64-linux" ];
  };
}
