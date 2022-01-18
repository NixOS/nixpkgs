{ fetchFromGitHub, lib, stdenv, pkg-config, autoreconfHook
, openssl, db48, boost, zlib, miniupnpc
, qrencode, glib, protobuf, yasm, libevent
, util-linux
, enable_Upnp ? false
, disable_Wallet ? false
, disable_Daemon ? false }:

with lib;
stdenv.mkDerivation rec {
  pname = "dashpay";
  version = "0.12.2.3";

  src = fetchFromGitHub {
    owner = "dashpay";
    repo= "dash";
    rev = "v${version}";
    sha256 = "sha256-DMoiUX8Q0HcBHA6ZIN58uPsTnHjEJMi8eGG2DW8z17Q=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [ glib openssl db48 yasm boost zlib libevent
                  miniupnpc protobuf qrencode util-linux ];


  configureFlags = [ "--with-boost-libdir=${boost.out}/lib --with-gui=no" ]
                    ++ optional enable_Upnp "--enable-upnp-default"
                    ++ optional disable_Wallet "--disable-wallet"
                    ++ optional disable_Daemon "--disable-daemon"
                    ;

  meta = {
    description = "A decentralized key/value registration and transfer system";
    longDescription = ''
      Dash (DASH) is an open sourced, privacy-centric digital currency
      with instant transactions.  It allows you to keep your finances
      private as you make transactions without waits, similar to cash.
    '';
    homepage = "https://www.dash.org";
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
