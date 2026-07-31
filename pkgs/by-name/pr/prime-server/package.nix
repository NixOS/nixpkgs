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
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "kevinkreiser";
    repo = "prime_server";
    tag = finalAttrs.version;
    hash = "sha256-B6vy/y4PDEpnxXuMpAisBq5avNpW84q/+9zbuNBOnko=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [ libsodium ];
  propagatedBuildInputs = [
    curl
    czmq
    zeromq
  ];

  meta = {
    description = "Non-blocking (web)server API for distributed computing and SOA based on zeromq";
    homepage = "https://github.com/kevinkreiser/prime_server";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.Thra11 ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
