{ stdenv, fetchurl, pkgconfig, autoreconfHook, openssl, db48, boost
, zlib, miniupnpc, qt4, utillinux, protobuf, qrencode, curl ? null
, withGui, withXT ? false }:

assert withXT -> curl != null;

with stdenv.lib;
stdenv.mkDerivation rec{

  name = "bitcoin" + (toString (optional (!withGui) "d"))
                   + (toString (optional (withXT) "-xt")) + "-" + version;
  version = if withXT then xt_version else core_version;
  src     = if withXT then xt_src     else core_src;

  core_version = "0.11.0";
  core_src = fetchurl {
    urls = [ "https://bitcoin.org/bin/bitcoin-core-${core_version}/bitcoin-${core_version}.tar.gz"
             "mirror://sourceforge/bitcoin/Bitcoin/bitcoin-${core_version}/bitcoin-${core_version}.tar.gz"
           ];
    sha256 = "51ba1756addfa71567559e3f22331c1d908a63571891287689fff7113035d09f";
  };

  xt_version = "0.11A";
  xt_src = fetchurl {
    url = "https://github.com/bitcoinxt/bitcoinxt/archive/v${xt_version}.tar.gz";
    sha256 = "129cbqf6bln6rhdk70c6nfwdjk6afvsaaw4xdyp0pnfand8idz7n";
  };

  buildInputs = [ pkgconfig autoreconfHook openssl db48 boost zlib
                  miniupnpc utillinux protobuf ]
                  ++ optionals withGui [ qt4 qrencode ]
                  ++ optionals withXT  [ curl ];

  configureFlags = [ "--with-boost-libdir=${boost.lib}/lib" ]
                     ++ optionals withGui [ "--with-gui=qt4" ];

  meta = {
    description = "Peer-to-peer electronic cash system";
    longDescription= ''
      Bitcoin is a free open source peer-to-peer electronic cash system that is
      completely decentralized, without the need for a central server or trusted
      parties. Users hold the crypto keys to their own money and transact directly
      with each other, with the help of a P2P network to check for double-spending.
    '';
    homepage = if withXT
      then "http://bitcoinxt.software/"
      else "http://www.bitcoin.org/";
    maintainers = with maintainers; [ roconnor AndersonTorres jefdaj ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
