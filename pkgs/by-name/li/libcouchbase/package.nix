{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libevent,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcouchbase";
  version = "3.3.19";

  src = fetchFromGitHub {
    owner = "couchbase";
    repo = "libcouchbase";
    rev = finalAttrs.version;
    sha256 = "sha256-DE1hSHgxaRH1Kh0dQFlxBkGGp0jmwZdaExxyZnv+abo=";
  };

  cmakeFlags = [ "-DLCB_NO_MOCK=ON" ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    libevent
    openssl
  ];

  # Running tests in parallel does not work
  enableParallelChecking = false;

  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = {
    description = "C client library for Couchbase";
    homepage = "https://github.com/couchbase/libcouchbase";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
})
