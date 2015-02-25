{ stdenv, fetchurl
, pkgconfig, autoreconfHook
, openssl, db48, boost, zlib, miniupnpc
, glib, protobuf, utillinux, qt4, qrencode
, withGui }:

with stdenv.lib;
stdenv.mkDerivation rec {

  name = "litecoin" + (toString (optional (!withGui) "d")) + "-" + version;
  version = "0.9.3-preview5";

  src = fetchurl {
    url = "https://github.com/litecoin-project/litecoin/archive/v${version}.tar.gz";
    sha256 = "0nnfz4s2g28jb5fqy6cabsryp3h2amzlyslr6g6k8r1vmzvx5ym6";
  };

  buildInputs = [ pkgconfig autoreconfHook openssl
                  openssl db48 boost zlib miniupnpc glib protobuf utillinux ]
                  ++ optionals withGui [ qt4 qrencode ];

  configureFlags = [ "--with-boost-libdir=${boost.lib}/lib" ]
                     ++ optionals withGui [ "--with-gui=qt4" ];

  meta = with stdenv.lib; {
    description = "A lite version of Bitcoin using scrypt as a proof-of-work algorithm";
    longDescription= ''
      Litecoin is a peer-to-peer Internet currency that enables instant payments
      to anyone in the world. It is based on the Bitcoin protocol but differs
      from Bitcoin in that it can be efficiently mined with consumer-grade hardware.
      Litecoin provides faster transaction confirmations (2.5 minutes on average)
      and uses a memory-hard, scrypt-based mining proof-of-work algorithm to target
      the regular computers and GPUs most people already have.
      The Litecoin network is scheduled to produce 84 million currency units.
    '';
    homepage = https://litecoin.org/;
    platforms = platforms.unix;
    license = licenses.mit;
    maintainers = with maintainers; [ offline AndersonTorres ];  
  };
}
