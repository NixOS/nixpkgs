{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, unbound, openssl, boost
, lmdb, miniupnpc, readline }:

stdenv.mkDerivation rec {
  pname = "masari";
  version = "0.1.4.0";

  src = fetchFromGitHub {
    owner = "masari-project";
    repo = "masari";
    rev = "v${version}";
    sha256 = "0l6i21wkq5f6z8xr756i7vqgkzk7lixaa31ydy34fkfcqxppgxz3";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ boost miniupnpc openssl lmdb unbound readline ];

  meta = with lib; {
    description = "scalability-focused, untraceable, secure, and fungible cryptocurrency using the RingCT protocol";
    homepage = "https://www.getmasari.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
