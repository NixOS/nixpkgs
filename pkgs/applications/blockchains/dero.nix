{ lib, stdenv, fetchFromGitHub, cmake, pkgconfig, unbound, openssl, boost
, lmdb, miniupnpc, readline }:

stdenv.mkDerivation rec {
  pname = "dero";
  version = "0.11.7";

  src = fetchFromGitHub {
    owner = "deroproject";
    repo = "dero";
    rev = "v${version}";
    sha256 = "1v8b9wbmqbpyf4jpc0v276qzk3hc5fpddcmwvv5k5yfi30nmbh5c";
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
