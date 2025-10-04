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
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "ithewei";
    repo = "libhv";
    rev = "v${finalAttrs.version}";
    hash = "sha256-N2YD84eORA5nDpeeqy9jCvRx86PkRaKLzI6LF1AnHtU=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    curl
    openssl
  ];

  cmakeFlags = [
    "-DENABLE_UDS=ON"
    "-DWITH_MQTT=ON"
    "-DWITH_CURL=ON"
    "-DWITH_NGHTTP2=ON"
    "-DWITH_OPENSSL=ON"
    "-DWITH_KCP=ON"
  ];

  meta = with lib; {
    description = "C/c++ network library for developing TCP/UDP/SSL/HTTP/WebSocket/MQTT client/server";
    homepage = "https://github.com/ithewei/libhv";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
})
