{ lib, stdenv, fetchFromGitHub, pkg-config, autoreconfHook, db5
, openssl, boost, zlib, miniupnpc, libevent, protobuf, qtbase ? null
, wrapQtAppsHook ? null, qttools ? null, qmake ? null, qrencode, withGui
, hexdump, Cocoa ? null }:

with lib;
stdenv.mkDerivation rec {
  pname = "dogecoin" + (optionalString (!withGui) "d");
  version = "1.14.3";

  src = fetchFromGitHub {
    owner = "dogecoin";
    repo = "dogecoin";
    rev = "v${version}";
    sha256 = "sha256-kozUnIislQDtgjeesYHKu4sB1j9juqaWvyax+Lb/0pc=";
  };

  preConfigure = lib.optionalString withGui ''
    export LRELEASE=${lib.getDev qttools}/bin/lrelease
  '';

  nativeBuildInputs = [ pkg-config autoreconfHook hexdump ]
    ++ optionals withGui [ wrapQtAppsHook qttools ];

  buildInputs = [ openssl db5 openssl protobuf boost zlib miniupnpc libevent ]
    ++ optionals withGui [ qtbase qrencode Cocoa ];

  configureFlags = [ "--with-incompatible-bdb" "--with-boost-libdir=${boost.out}/lib" ]
    ++ optionals withGui [ "--with-gui" ];

  meta = {
    description = "Wow, such coin, much shiba, very rich";
    longDescription = ''
      Dogecoin is a decentralized, peer-to-peer digital currency that
      enables you to easily send money online. Think of it as "the
      internet currency."
      It is named after a famous Internet meme, the "Doge" - a Shiba Inu dog.
    '';
    homepage = "http://www.dogecoin.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ edwtjo offline ];
    platforms = platforms.unix;
  };
}
