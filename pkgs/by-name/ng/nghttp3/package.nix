{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  curlHTTP3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nghttp3";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "ngtcp2";
    repo = "nghttp3";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8WQfXzzF3K0IJNectrE1amQ6Njq4pZslrcVun6Uhi6E=";
    fetchSubmodules = true;
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_STATIC_LIB" false)
  ];

  doCheck = true;

  passthru.tests = {
    inherit curlHTTP3;
  };

  meta = {
    homepage = "https://github.com/ngtcp2/nghttp3";
    changelog = "https://github.com/ngtcp2/nghttp3/releases/tag/${finalAttrs.src.tag}";
    description = "Implementation of HTTP/3 mapping over QUIC and QPACK in C";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ izorkin ];
  };
})
