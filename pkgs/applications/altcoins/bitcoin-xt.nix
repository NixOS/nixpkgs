{ stdenv, fetchurl, pkgconfig, autoreconfHook, openssl, db48, boost
, zlib, miniupnpc, qt4, utillinux, protobuf, qrencode, curl
, withGui }:

with stdenv.lib;
stdenv.mkDerivation rec{

  name = "bitcoin" + (toString (optional (!withGui) "d")) + "-xt-" + version;
  version = "0.11D";

  src = fetchurl {
    url = "https://github.com/bitcoinxt/bitcoinxt/archive/v${version}.tar.gz";
    sha256 = "09r2i88wzqaj6mh66l3ngyfkm1a0dhwm5ibalj6y55wbxm9bvd36";
  };

  buildInputs = [ pkgconfig autoreconfHook openssl db48 boost zlib
                  miniupnpc utillinux protobuf curl ]
                  ++ optionals withGui [ qt4 qrencode ];

  configureFlags = [
    "--with-boost-libdir=${boost.lib}/lib"
    "--with-libcurl-headers=${curl.dev}/include"
  ] ++ optionals withGui [ "--with-gui=qt4" ];

  meta = {
    description = "Peer-to-peer electronic cash system (XT client)";
    longDescription= ''
      Bitcoin is a free open source peer-to-peer electronic cash system that is
      completely decentralized, without the need for a central server or trusted
      parties. Users hold the crypto keys to their own money and transact directly
      with each other, with the help of a P2P network to check for double-spending.

      Bitcoin XT is an implementation of a Bitcoin full node, based upon the
      source code of Bitcoin Core. It is built by taking the latest stable
      Core release, applying a series of patches, and then doing deterministic
      builds so anyone can check the downloads correspond to the source code. 
    '';
    homepage = "https://bitcoinxt.software/";
    maintainers = with maintainers; [ jefdaj ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
