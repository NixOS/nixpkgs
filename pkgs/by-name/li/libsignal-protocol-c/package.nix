{ lib, stdenv, fetchFromGitHub, cmake, openssl }:

stdenv.mkDerivation rec {
  pname = "libsignal-protocol-c";
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "signalapp";
    repo = "libsignal-protocol-c";
    rev = "v${version}";
    sha256 = "0z5p03vk15i6h870azfjgyfgxhv31q2vq6rfhnybrnkxq2wqzwhk";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ openssl ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];

  outputs = [ "out" "dev" ];

  meta = with lib; {
    description = "Signal Protocol C Library";
    homepage = "https://github.com/signalapp/libsignal-protocol-c";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ orivej ];
  };
}
