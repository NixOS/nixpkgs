{ lib, stdenv, fetchFromGitHub, cmake, unbound, openssl, boost
, libunwind, lmdb, miniupnpc }:

stdenv.mkDerivation rec {
  name = "sumokoin-${version}";
  version = "0.2.0.0";

  src = fetchFromGitHub {
    owner = "sumoprojects";
    repo = "sumokoin";
    rev = "v${version}";
    sha256 = "0ndgcawhxh3qb3llrrilrwzhs36qpxv7f53rxgcansbff9b3za6n";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ unbound openssl boost libunwind lmdb miniupnpc ];

  postPatch = ''
    substituteInPlace src/blockchain_db/lmdb/db_lmdb.cpp --replace mdb_size_t size_t
  '';

  cmakeFlags = [
    "-DLMDB_INCLUDE=${lmdb}/include"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Sumokoin is a fork of Monero and a truely fungible cryptocurrency";
    homepage = https://www.sumokoin.org/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.linux;
  };
}
