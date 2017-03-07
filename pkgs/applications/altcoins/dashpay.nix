{ fetchFromGitHub, stdenv, pkgconfig, autoreconfHook
, openssl, db48, boost, zlib, miniupnpc
, qrencode, glib, protobuf, yasm, libevent
, utillinux
, with_gui ? true, qt4
, enable_upnp ? false 
, disable_wallet ? false
, disable_daemon ? false }:

assert with_gui -> qt4 !=null;

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "dashpay-${version}";
  version = "0.12.1.3";

  src = fetchFromGitHub {
    owner = "dashpay";
    repo= "dash";
    rev = "v${version}";
    sha256 = "0h0fxhh30wy5vp06l1mkswhz565qs6j9y0dm84fmn28rdfvhv2aj";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ glib openssl db48 yasm boost zlib libevent 
                  miniupnpc protobuf qrencode utillinux ]
                  ++ optional with_gui qt4
                  ;

  configureFlags = [ "--with-boost-libdir=${boost.out}/lib" ]
                    ++ optional with_gui "--with-gui=qt4"
                    ++ optional (!with_gui) "--with-gui=no"
                    ++ optional enable_upnp "--enable-upnp-default"
                    ++ optional disable_wallet "--disable-wallet"
                    ++ optional disable_daemon "--disable-wallet"
                    ;

  meta = with stdenv.lib; {
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
