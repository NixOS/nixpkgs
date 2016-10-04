{ stdenv , fetchurl
, pkgconfig, autoreconfHook
, db5, openssl, boost, zlib, miniupnpc
, glib, protobuf, utillinux, qt4, qrencode
, withGui }:

with stdenv.lib;
stdenv.mkDerivation rec {

  name = "dogecoin" + (toString (optional (!withGui) "d")) + "-" + version;
  version = "1.8.2";

  src = fetchurl {
    url = "https://github.com/dogecoin/dogecoin/archive/v${version}.tar.gz";
    sha256 = "17jxsxsrsz3qy2hxdpw78vcbnnd0nq614iy42ypzhw4pdpz0s1l7";
  };

  buildInputs = [ autoreconfHook pkgconfig openssl
                  db5 openssl utillinux protobuf boost zlib miniupnpc ]
                  ++ optionals withGui [ qt4 qrencode ];

  # BSD DB5 location
  patchPhase = ''
    sed -i \
      -e 's,BDB_CPPFLAGS=$,BDB_CPPFLAGS="-I${db5}/include",g' \
      -e 's,BDB_LIBS=$,BDB_LIBS="-L${db5}/lib",g' \
      -e 's,bdbdirlist=$,bdbdirlist="${db5}/include",g' \
      src/m4/dogecoin_find_bdb51.m4
  '';

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
    platforms = with platforms; linux;
  };
}
