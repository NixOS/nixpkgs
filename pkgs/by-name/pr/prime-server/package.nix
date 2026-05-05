{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  curl,
  zeromq,
  czmq,
  libsodium,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "prime-server";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "kevinkreiser";
    repo = "prime_server";
    tag = finalAttrs.version;
    sha256 = "sha256-POfr0gU64bK4xtIOWOs/7KvSbxDD58rJTjOERLL2qjM=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    curl
    zeromq
    czmq
    libsodium
  ];

  # https://github.com/kevinkreiser/prime_server/issues/95
  env.NIX_CFLAGS_COMPILE = toString [ "-Wno-error=unused-variable" ];

  meta = {
    description = "Non-blocking (web)server API for distributed computing and SOA based on zeromq";
    homepage = "https://github.com/kevinkreiser/prime_server";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.Thra11 ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
