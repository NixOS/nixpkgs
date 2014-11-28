{ fetchurl, stdenv, pkgconfig
, openssl, db48, boost, zlib, miniupnpc, qt4, qrencode, glib, protobuf
, utillinux, autogen, autoconf, autobuild, automake, autoreconfHook, db }:

with stdenv.lib;

let
  buildAltcoin = makeOverridable ({walletName, gui ? true, ...}@a:
    stdenv.mkDerivation ({
      name = "${walletName}${toString (optional (!gui) "d")}-${a.version}";
      buildInputs = [ pkgconfig openssl db48 boost zlib miniupnpc ]
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
        maintainers = [ maintainers.offline ] ++ a.extraMaintainers;
      };
    } // a)
  );

in rec {
  inherit buildAltcoin;

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
      description = "A decentralized key/value registration and transfer system based on Bitcoin technology";
      homepage = http://namecoin.info;
    };
  };

  darkcoin = buildAltcoin rec {
    walletName = "darkcoin";
    version = "0.9.13.15";

    src = fetchurl {
      url = "https://github.com/darkcoin/darkcoin/archive/v${version}.tar.gz";
      sha256 = "1kly2y3g4dr1jwwf81smqvc7k662x6rvg4ggmxva1yaifb67bgjb";
    };

    extraBuildInputs = [ glib ];

    meta = {
      description = "A decentralized key/value registration and transfer system";
      longDescription = ''
        Darkcoin (DRK) is an open sourced, privacy-centric digital
        currency. It allows you keep your finances private as you make
        transactions, similar to cash.
      '';
      homepage = http://darkcoin.io;
      extraMaintainers = [ maintainers.AndersonTorres ];
    };
  };
  darkcoind = darkcoin.override { gui = false; };

}
