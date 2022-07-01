{ lib, stdenv, fetchurl, curl, gnunet, jansson, libgcrypt, libmicrohttpd
, qrencode, libsodium, libtool, pkg-config, postgresql, sqlite }:

let
  gnunet' = gnunet.override { postgresqlSupport = true; };

  mkTaler = { pname, version, sha256 }:
    extraAttrs:
    stdenv.mkDerivation (extraAttrs // {
      inherit pname version;
      src = fetchurl {
        url = "mirror://gnu/taler/${pname}-${version}.tar.gz";
        inherit sha256;
      };
      enableParallelBuilding = true;
      meta = with lib; {
        broken = (stdenv.isLinux && stdenv.isAarch64);
        description = "Anonymous, taxable payment system.";
        homepage = "https://taler.net/";
        license = licenses.agpl3Plus;
        maintainers = with maintainers; [ ehmry ];
        platforms = platforms.gnu ++ platforms.linux;
      };
    });

in rec {

  taler-exchange = mkTaler {
    pname = "taler-exchange";
    version = "0.8.1";
    sha256 = "sha256-MPt3n1JXd0Y89b1qCuF6YxptSr7henfYp97JTq1Z+x4=";
  } {
    buildInputs = [
      curl
      jansson
      libgcrypt
      libmicrohttpd
      libsodium
      libtool
      postgresql
      # sqlite
    ];
    propagatedBuildInputs = [ gnunet' ];
    patches = [ ./exchange-fix-6665.patch ];
  };

  taler-merchant = mkTaler {
    pname = "taler-merchant";
    version = "0.8.0";
    sha256 = "sha256-scrFLXeoQirGqhc+bSQKRl84PfUvjrp1uxF7pfOIB9Q=";
  } {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = taler-exchange.buildInputs ++ [ qrencode taler-exchange ];
    propagatedBuildInputs = [ gnunet' ];
    PKG_CONFIG = "${pkg-config}/bin/pkg-config";
  };

}
