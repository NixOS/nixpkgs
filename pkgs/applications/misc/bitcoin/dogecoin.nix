{ fetchurl, stdenv, pkgconfig
, openssl, boost, zlib, miniupnpc, qt4, qrencode, glib, protobuf
, utillinux, autogen, autoconf, autobuild, automake, db }:

with stdenv.lib;

let

  mkAutotoolCoin =
  { name, version, withGui, src, meta }:

  stdenv.mkDerivation {
    inherit src meta;

    name = name + (toString (optional (!withGui) "d")) + "-" + version;

    buildInputs = [ autogen autoconf automake pkgconfig openssl
                    boost zlib miniupnpc db utillinux protobuf ]
                  ++ optionals withGui [ qt4 qrencode ];

    patchPhase = ''
      sed -i \
        -e 's,BDB_CPPFLAGS=$,BDB_CPPFLAGS="-I${db}/include",g' \
        -e 's,BDB_LIBS=$,BDB_LIBS="-L${db}/lib",g' \
        -e 's,bdbdirlist=$,bdbdirlist="${db}/include",g' \
        src/m4/dogecoin_find_bdb51.m4
    '';

    configurePhase = ''
      ./autogen.sh \
      && ./configure --prefix=$out \
                     --with-incompatible-bdb \
                     --with-boost-libdir=${boost}/lib \
                     ${ if withGui then "--with-gui" else "" }
    '';

    installPhase = ''
      install -D "src/dogecoin-cli" "$out/bin/dogecoin-cli"
      install -D "src/dogecoind" "$out/bin/dogecoind"
      ${ if withGui then "install -D src/qt/dogecoin-qt $out/bin/dogecoin-qt" else "" }
    '';

  };

  mkDogeCoin = { withGui }:

  mkAutotoolCoin rec {
    name = "dogecoin";
    version = "1.8.0";
    inherit withGui;

    src = fetchurl {
      url = "https://github.com/dogecoin/dogecoin/archive/v${version}.tar.gz";
      sha256 = "8a33958c04213cd621aa3c86910477813af22512f03b47c98995d20d31f3f935";
    };

    meta = {
      description = "Wow, such coin, much shiba, very rich";
      longDescription = "wow";
      homepage = http://www.dogecoin.com/;
      license = licenses.mit;
      maintainers = with maintainers; [ edwtjo offline ];
    };
  };

in {

  dogecoin = mkDogeCoin { withGui = true; };
  dogecoind = mkDogeCoin { withGui = false; };

}
