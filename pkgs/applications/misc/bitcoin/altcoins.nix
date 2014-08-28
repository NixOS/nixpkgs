{ fetchurl, stdenv, pkgconfig
, openssl, db48, boost, zlib, miniupnpc, qt4, qrencode, glib, protobuf
, utillinux, autogen, autoconf, autobuild, automake, db }:

with stdenv.lib;

let
  buildAltcoin = makeOverridable ({walletName, gui ? true, ...}@a:
    stdenv.mkDerivation ({
      name = "${walletName}${toString (optional (!gui) "d")}-${a.version}";
      buildInputs = [ openssl db48 boost zlib miniupnpc ]
        ++ optionals gui [ qt4 qrencode ] ++ a.extraBuildInputs or [];

      configurePhase = optional gui "qmake";

      preBuild = optional (!gui) "cd src";
      makefile = optional (!gui) "makefile.unix";

      installPhase = if gui then ''
        install -D "${walletName}-qt" "$out/bin/${walletName}-qt"
      '' else ''
        install -D "${walletName}d" "$out/bin/${walletName}d"
      '';

      passthru.walletName = walletName;

      meta = {
        platforms = platforms.unix;
        license = license.mit;
        maintainers = [ maintainers.offline ];
      };
    } // a)
  );

in rec {
  inherit buildAltcoin;

  litecoin = buildAltcoin rec {
    walletName = "litecoin";
    version = "0.8.5.3-rc3";

    src = fetchurl {
      url = "https://github.com/litecoin-project/litecoin/archive/v${version}.tar.gz";
      sha256 = "1z4a7bm3z9kd7n0s38kln31z8shsd32d5d5v3br5p0jlnr5g3lk7";
    };

    meta = {
      description = "Litecoin is a lite version of Bitcoin using scrypt as a proof-of-work algorithm.";
      longDescription= ''
        Litecoin is a peer-to-peer Internet currency that enables instant payments
        to anyone in the world. It is based on the Bitcoin protocol but differs
        from Bitcoin in that it can be efficiently mined with consumer-grade hardware.
        Litecoin provides faster transaction confirmations (2.5 minutes on average)
        and uses a memory-hard, scrypt-based mining proof-of-work algorithm to target
        the regular computers and GPUs most people already have.
        The Litecoin network is scheduled to produce 84 million currency units.
      '';
      homepage = https://litecoin.org/;
    };
  };
  litecoind = litecoin.override { gui = false; };

  namecoin = buildAltcoin rec {
    walletName = "namecoin";
    version = "0.3.51.00";
    gui = false;

    src = fetchurl {
      url = "https://github.com/namecoin/namecoin/archive/nc${version}.tar.gz";
      sha256 = "0r6zjzichfjzhvpdy501gwy9h3zvlla3kbgb38z1pzaa0ld9siyx";
    };

    patches = [ ./namecoin_dynamic.patch ];

    extraBuildInputs = [ glib ];

    meta = {
      description = "Namecoin is a decentralized key/value registration and transfer system based on Bitcoin technology.";
      homepage = http://namecoin.info;
    };
  };

  dogecoin = (buildAltcoin rec {
    walletName = "dogecoin";
    version = "1.8.0";

    src = fetchurl {
      url = "https://github.com/dogecoin/dogecoin/archive/v${version}.tar.gz";
      sha256 = "8a33958c04213cd621aa3c86910477813af22512f03b47c98995d20d31f3f935";
    };

    extraBuildInputs = [ autogen autoconf automake pkgconfig db utillinux protobuf ];

    meta = {
      description = "Wow, such coin, much shiba, very rich";
      longDescription = "wow";
      homepage = http://www.dogecoin.com/;
      maintainers = [ maintainers.offline maintainers.edwtjo ];
    };
  }).override rec {
    patchPhase = ''
      sed -i \
        -e 's,BDB_CPPFLAGS=$,BDB_CPPFLAGS="-I${db}/include",g' \
        -e 's,BDB_LIBS=$,BDB_LIBS="-L${db}/lib",g' \
        -e 's,bdbdirlist=$,bdbdirlist="${db}/include",g' \
        src/m4/dogecoin_find_bdb51.m4
    '';
    dogeConfigure = ''
      ./autogen.sh \
      && ./configure --prefix=$out \
                     --with-incompatible-bdb \
                     --with-boost-libdir=${boost}/lib \
    '';
    dogeInstall = ''
      install -D "src/dogecoin-cli" "$out/bin/dogecoin-cli"
      install -D "src/dogecoind" "$out/bin/dogecoind"
    '';
    configurePhase = dogeConfigure + "--with-gui";
    installPhase = dogeInstall + "install -D src/qt/dogecoin-qt $out/bin/dogecoin-qt";
  };

  dogecoind = dogecoin.override rec {
    gui = false;
    makefile = "Makefile";
    preBuild = "";
    configurePhase = dogecoin.dogeConfigure + "--without-gui";
    installPhase = dogecoin.dogeInstall;
  };

}
