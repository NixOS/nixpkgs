{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  curlHTTP3,
}:

stdenv.mkDerivation rec {
  pname = "nghttp3";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "ngtcp2";
    repo = "nghttp3";
    rev = "v${version}";
    hash = "sha256-CTra8vmpIig8LX7RWqRzhWhX9yn0RnFrnV/kYPgZgJk=";
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

  meta = with lib; {
    homepage = "https://github.com/ngtcp2/nghttp3";
    description = "nghttp3 is an implementation of HTTP/3 mapping over QUIC and QPACK in C";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ izorkin ];
  };
}
