{ stdenv , fetchFromGitHub
, pkgconfig, autoreconfHook
, db5, openssl, boost, zlib, miniupnpc
, glib, protobuf, utillinux, qt4, qrencode
, withGui }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "dogecoin" + (toString (optional (!withGui) "d")) + "-" + version;
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "dogecoin";
    repo = "dogecoin";
    rev = "v${version}";
    sha256 = "16q3rldj04hkzzjd23h0knszqr5dgixizy4iyc129mz8wa8pbnvy";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ openssl db5 openssl utillinux 
                  protobuf boost zlib miniupnpc ]
                  ++ optionals withGui [ qt4 qrencode ];

  configureFlags = [ "--with-incompatible-bdb"
                     "--with-boost-libdir=${boost.out}/lib" ]
                     ++ optionals withGui [ "--with-gui" ];

  meta = {
    description = "Wow, such coin, much shiba, very rich";
    longDescription = ''
      Dogecoin is a decentralized, peer-to-peer digital currency that
      enables you to easily send money online. Think of it as "the
      internet currency."
      It is named after a famous Internet meme, the "Doge" - a Shiba Inu dog.
    '';
    homepage = http://www.dogecoin.com/;
    license = licenses.mit;
    maintainers = with maintainers; [ edwtjo offline AndersonTorres ];
    platforms = platforms.linux;
  };
}
