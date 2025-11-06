{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  curl,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libhv";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "ithewei";
    repo = "libhv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YIWXdAZsWeSdtPtBaf/t9t68dFKw2nY0bvgMrzCEE5U=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    curl
    openssl
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_UDS" true)
    (lib.cmakeBool "WITH_MQTT" true)
    (lib.cmakeBool "WITH_CURL" true)
    (lib.cmakeBool "WITH_NGHTTP2" true)
    (lib.cmakeBool "WITH_OPENSSL" true)
    (lib.cmakeBool "WITH_KCP" true)
  ];

  meta = {
    description = "C/c++ network library for developing TCP/UDP/SSL/HTTP/WebSocket/MQTT client/server";
    homepage = "https://github.com/ithewei/libhv";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
  };
})
