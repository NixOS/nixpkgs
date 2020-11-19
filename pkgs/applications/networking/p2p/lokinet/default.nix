{ stdenv, fetchFromGitHub, cmake, pkgconfig, libuv, libsodium, unbound, zeromq
, sqlite, openssl, libevent, systemd, loki-mq }:

stdenv.mkDerivation rec {
  pname = "lokinet";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "loki-project";
    repo = "loki-network";
    rev = "v${version}";
    sha256 = "186g8d5lzm5gif4vxcxxb4vq98nbscbw9803zpif5dlik80mgwal";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [
    libuv libsodium unbound zeromq sqlite openssl libevent systemd loki-mq
  ];
  cmakeFlags = [ "-DWITH_LTO=OFF" ];

  meta = with stdenv.lib; {
    description = "Anonymous, decentralized and IP based overlay network for the internet";
    homepage = "https://lokinet.org/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chiiruno ];
  };
}
