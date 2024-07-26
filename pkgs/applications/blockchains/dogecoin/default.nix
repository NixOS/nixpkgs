{ lib, stdenv , fetchFromGitHub
, pkg-config, autoreconfHook
, db5, openssl, boost, zlib, miniupnpc, libevent
, protobuf, qtbase ? null
, wrapQtAppsHook ? null, qttools ? null, qmake ? null, qrencode
, withGui, withUpnp ? true, withUtils ? true, withWallet ? true
, withZmq ? true, zeromq, util-linux ? null, Cocoa ? null }:

stdenv.mkDerivation rec {
  pname = "dogecoin" + lib.optionalString (!withGui) "d";
  version = "1.14.6";

  src = fetchFromGitHub {
    owner = "dogecoin";
    repo = "dogecoin";
    rev = "v${version}";
    sha256 = "sha256-PmbmmA2Mq07dwB3cI7A9c/ewtu0I+sWvQT39Yekm/sU=";
  };

  preConfigure = lib.optionalString withGui ''
    export LRELEASE=${lib.getDev qttools}/bin/lrelease
  '';

  nativeBuildInputs = [ pkg-config autoreconfHook util-linux ]
    ++ lib.optionals withGui [ wrapQtAppsHook qttools ];

  buildInputs = [ openssl protobuf boost zlib libevent ]
    ++ lib.optionals withGui [ qtbase qrencode ]
    ++ lib.optionals withUpnp [ miniupnpc ]
    ++ lib.optionals withWallet [ db5 ]
    ++ lib.optionals withZmq [ zeromq ]
    ++ lib.optionals stdenv.isDarwin [ Cocoa ];

  configureFlags = [
    "--with-incompatible-bdb"
    "--with-boost-libdir=${boost.out}/lib"
  ] ++ lib.optionals (!withGui) [ "--with-gui=no" ]
    ++ lib.optionals (!withUpnp) [ "--without-miniupnpc" ]
    ++ lib.optionals (!withUtils) [ "--without-utils" ]
    ++ lib.optionals (!withWallet) [ "--disable-wallet" ]
    ++ lib.optionals (!withZmq) [ "--disable-zmq" ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Wow, such coin, much shiba, very rich";
    longDescription = ''
      Dogecoin is a decentralized, peer-to-peer digital currency that
      enables you to easily send money online. Think of it as "the
      internet currency."
      It is named after a famous Internet meme, the "Doge" - a Shiba Inu dog.
    '';
    homepage = "https://www.dogecoin.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ edwtjo offline ];
    platforms = platforms.unix;
    broken = true;
  };
}
