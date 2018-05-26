{ lib, stdenv, fetchFromGitHub, cmake, pkgconfig, unbound, openssl, boost
, libunwind, lmdb, miniupnpc, readline }:

stdenv.mkDerivation rec {
  name = "dero-${version}";
  version = "0.11.6";

  src = fetchFromGitHub {
    owner = "deroproject";
    repo = "dero";
    rev = "v${version}";
    sha256 = "0jc5rh2ra4wra04dwv9sydid5ij5930s38mhzq3qkdjyza1ahmsr";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ boost miniupnpc openssl lmdb unbound readline ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Secure, private blockchain with smart contracts based on Monero";
    homepage = "https://dero.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.linux;
  };
}
