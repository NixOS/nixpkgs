{ fetchzip, stdenv, pkgconfig, autoreconfHook
, openssl, db48, boost, zlib, miniupnpc
, qt4, qrencode, glib, protobuf, yasm
, utillinux }:

with stdenv.lib;
stdenv.mkDerivation rec {

  name = "dashpay-${meta.version}";

  src = fetchzip {
    url = "https://github.com/dashpay/dash/archive/v${meta.version}.tar.gz";
    sha256 = "19bk7cviy3n2dpj4kr3i6i0i3ac2l5ri8ln1a51nd3n90k016wnx";
  };

  buildInputs = [ pkgconfig autoreconfHook glib openssl db48 yasm
                  boost zlib miniupnpc protobuf qt4 qrencode utillinux ];

  configureFlags = [ "--with-boost-libdir=${boost.out}/lib" ];

  meta = with stdenv.lib; {
    version = "0.12.0.55";
    description = "A decentralized key/value registration and transfer system";
    longDescription = ''
      Dash (DASH) is an open sourced, privacy-centric digital currency
      with instant transactions.  It allows you to keep your finances
      private as you make transactions without waits, similar to cash.
    '';
    homepage = http://dashpay.io;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
