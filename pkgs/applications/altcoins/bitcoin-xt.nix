{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook, openssl, db48, boost
, zlib, miniupnpc, qt4, utillinux, protobuf, qrencode, curl, libevent
, withGui }:

with stdenv.lib;
stdenv.mkDerivation rec{

  name = "bitcoin" + (toString (optional (!withGui) "d")) + "-xt-" + version;
  version = "0.11G2";

  src = fetchFromGitHub {
    owner = "bitcoinxt";
    repo = "bitcoinxt";
    rev = "v${version}";
    sha256 = "071rljvsabyc9j64v248qfb7zfqpfl84hpsnvlavin235zljq8qs";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ openssl db48 boost zlib libevent
                  miniupnpc utillinux protobuf curl ]
                  ++ optionals withGui [ qt4 qrencode ];

  configureFlags = [
    "--with-boost-libdir=${boost.out}/lib"
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
    homepage = https://bitcoinxt.software/;
    maintainers = with maintainers; [ jefdaj ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
