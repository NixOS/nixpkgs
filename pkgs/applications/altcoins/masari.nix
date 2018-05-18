{ lib, stdenv, fetchFromGitHub, cmake, pkgconfig, unbound, openssl, boost
, lmdb, miniupnpc, readline }:

stdenv.mkDerivation rec {
  name = "masari-${version}";
  version = "0.1.4.0";

  src = fetchFromGitHub {
    owner = "masari-project";
    repo = "masari";
    rev = "v${version}";
    sha256 = "0l6i21wkq5f6z8xr756i7vqgkzk7lixaa31ydy34fkfcqxppgxz3";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ boost miniupnpc openssl lmdb unbound readline ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "scalability-focused, untraceable, secure, and fungible cryptocurrency using the RingCT protocol";
    homepage = "https://www.getmasari.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.linux;
  };
}
