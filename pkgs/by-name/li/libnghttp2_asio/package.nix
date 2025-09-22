{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nghttp2,
  openssl,
  boost186,
}:

stdenv.mkDerivation {
  pname = "libnghttp2_asio";
  version = "0-unstable-2022-08-11";

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "nghttp2";
    repo = "nghttp2-asio";
    rev = "e877868abe06a83ed0a6ac6e245c07f6f20866b5";
    hash = "sha256-XQXRHLz0kvaIQq1nbqkJnETHR51FXMB1P9F/hQeZh6A=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    boost186
    nghttp2
    openssl
  ];

  meta = with lib; {
    description = "High level HTTP/2 C++ library";
    longDescription = ''
      libnghttp2_asio is C++ library built on top of libnghttp2
      and provides high level abstraction API to build HTTP/2
      applications. It depends on the Boost::ASIO library and
      OpenSSL. libnghttp2_asio provides both client and server APIs.
    '';
    homepage = "https://github.com/nghttp2/nghttp2-asio";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ izorkin ];
  };
}
