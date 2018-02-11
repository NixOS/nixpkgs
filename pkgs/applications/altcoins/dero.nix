{ lib, stdenv, fetchFromGitHub, cmake, pkgconfig, unbound, openssl, boost
, libunwind, lmdb, miniupnpc, readline }:

stdenv.mkDerivation rec {
  name = "dero-${version}";
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = "deroproject";
    repo = "dero";
    rev = "v${version}";
    sha256 = "0cv4yg2lkmkdhlc3753gnbg1nzldk2kxwdyizwhvanq3ycqban4b";
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
