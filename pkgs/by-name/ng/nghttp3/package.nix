{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  curlHTTP3,
}:

stdenv.mkDerivation rec {
  pname = "nghttp3";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "ngtcp2";
    repo = "nghttp3";
    rev = "v${version}";
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

  meta = with lib; {
    homepage = "https://github.com/ngtcp2/nghttp3";
    description = "Implementation of HTTP/3 mapping over QUIC and QPACK in C";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ izorkin ];
  };
}
