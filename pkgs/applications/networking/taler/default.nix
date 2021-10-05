{ lib, stdenv, fetchurl, curl, gnunet, jansson, libgcrypt, libmicrohttpd
, qrencode, libsodium, libtool, pkg-config, postgresql, sqlite, autoreconfHook, jinja2, recutils, wget, jq, gettext, texinfo}:

let
  gnunet' = gnunet.override { postgresqlSupport = true; };
in rec {
  taler-exchange = stdenv.mkDerivation rec {
    pname = "taler-exchange";
    version = "0.8.5";
    src = fetchurl {
      url = "http://ftp.gnu.org/gnu/taler/${pname}-${version}.tar.gz";
      sha256 = "sha256-jehQKkDYdDkEXen/LSn0gZi4tYpykYM92W35ZbSLNj4=";
    };
    postPatch = ''
      find . -name '*.sh' -exec sed -i 's%#!/bin/bash%#!${stdenv.shell}%g' {} \;
    '';
    enableParallelBuilding = true;
    nativeBuildInputs = [
      autoreconfHook
    ];
    buildInputs = [
      libgcrypt
      libmicrohttpd
      jansson
      libsodium
      postgresql
      curl
      jinja2
      recutils
      gettext
      texinfo # Fix 'makeinfo' is missing on your system.
    ];
    propagatedBuildInputs = [ gnunet' ];
    configureFlags = [ "--with-gnunet=${gnunet'}" ];
    checkInputs = [ wget curl ];
    meta = with lib; {
      description = ''
        Taler is an electronic payment system providing the ability to pay
        anonymously using digital cash.  Taler consists of a network protocol
        definition (using a RESTful API over HTTP), a Exchange (which creates
        digital coins), a Wallet (which allows customers to manage, store and
        spend digital coins), and a Merchant website which allows customers to
        spend their digital coins.  Naturally, each Merchant is different, but
        Taler includes code examples to help Merchants integrate Taler as a
        payment system.
      '';
      homepage = "https://taler.net/";
      license = licenses.agpl3Plus;
      platforms = platforms.gnu ++ platforms.linux;
    };
    # FIXME: at least one test wants to access a postgres db:
    # `ERROR Database connection to 'postgres:///talercheck' failed: could not connect to server: No such file or directory`
    doInstallCheck = false;
    installCheck = ''
      make check
    '';
  };

  taler-merchant = stdenv.mkDerivation rec {
    pname = "taler-merchant";
    version = "0.8.3";
    src = fetchurl {
      url = "http://ftp.gnu.org/gnu/taler/${pname}-${version}.tar.gz";
      sha256 = "sha256-n7YjJfY8HZevk9o4XbXs6isGFHLmusjCfEb+9maAK0U=";
    };
    postPatch = ''
      find . -name '*.sh' -exec sed -i 's%#!/bin/bash%#!${stdenv.shell}%g' {} \;
    '';
    nativeBuildInputs = [ pkg-config autoreconfHook ];
    buildInputs = taler-exchange.buildInputs ++ [
      qrencode
      taler-exchange
      # for ltdl.h
      libtool
    ];
    propagatedBuildInputs = [ gnunet' ];
    configureFlags = [
      "--with-gnunet=${gnunet'}"
      "--with-exchange=${taler-exchange}"
  ];
    preCheck = ''
        find . -name '*.sh' -exec sed -i 's%#!/bin/bash%#!${stdenv.shell}%g' {} \;
        find . -name '*.sh' -exec sed -i 's%#!/usr/bin/env bash%#!${stdenv.shell}%g' {} \;
      '';
    doCheck = false; # `make check` is meant to be run after installation
    checkInputs = [ jq ];
    doInstallCheck = true;
    installCheck = ''
      make check
    '';
    meta = with lib; {
      description = ''
        This is the GNU Taler merchant backend. It provides the logic that should run
        at every GNU Taler merchant.  The GNU Taler merchant is a RESTful backend that
        can be used to setup orders and process payments.  This component allows
        merchants to receive payments without invading the customers' privacy. Of
        course, this applies mostly for digital goods, as the merchant does not need
        to know the customer's physical address.
      '';
      homepage = "https://taler.net/";
      license = licenses.agpl3Plus;
    };
  };
}
