{ lib, stdenv, fetchgit, curl, gnunet, jansson, libgcrypt, libmicrohttpd_0_9_72
, qrencode, libsodium, libtool, libunistring, pkg-config, postgresql
, autoreconfHook, python39, recutils, wget, jq, gettext, texinfo
}:

let
  taler-merchant-backoffice = fetchgit {
    url = "https://git.taler.net/merchant-backoffice.git";
    # branch "prebuilt" as of 2022-07-01
    rev = "1ef7150f32960cb65ebea67839cd5023f29a3d1d";
    sha256 = "sha256-ZtLYWHi6l5DxFvDm8RFGUD0BiAfJXCZr/ggrP3Uw7/0=";
  };

in rec {
  taler-exchange = stdenv.mkDerivation rec {
    pname = "taler-exchange";
    version = "unstable-2022-07-17";

    src = fetchgit {
      url = "https://git.taler.net/exchange.git";
      rev = "93b45e62eef254eae68bc119b9770e97bae2c9fa";
      fetchSubmodules = true;
      sha256 = "sha256-BQxbwEf0wIkBOBVsPgMkMvUj4kFReXMUFTiSG0jXOJ0=";
    };

    nativeBuildInputs = [
      autoreconfHook
      pkg-config
    ];
    buildInputs = [
      libgcrypt
      libmicrohttpd_0_9_72
      jansson
      libsodium
      postgresql
      curl
      recutils
      gettext
      texinfo # Fix 'makeinfo' is missing on your system.
      libunistring
      python39.pkgs.jinja2
    ];
    propagatedBuildInputs = [ gnunet ];

    configureFlags = [ "--with-gnunet=${gnunet}" ];
    preConfigure = ''
      ./contrib/gana-update.sh
    '';

    enableParallelBuilding = true;

    checkInputs = [ wget curl ];
    doInstallCheck = true;
    checkTarget = "check";

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
      maintainers = with maintainers; [ astro ];
      platforms = platforms.linux;
    };
  };

  taler-merchant = stdenv.mkDerivation rec {
    pname = "taler-merchant";
    version = "unstable-2022-07-11";

    src = fetchgit {
      url = "https://git.taler.net/merchant.git";
      rev = "960dcacf25e51cc2bff359ea1fc86cdd3d9e6083";
      sha256 = "sha256-Wn11z6YjnylZl3z2JjBlrtZ1KHfQUHLIYWo5F+mAmNo=";
    };
    postUnpack = ''
      ln -s ${taler-merchant-backoffice}/spa.html $sourceRoot/contrib/
    '';

    nativeBuildInputs = [ pkg-config autoreconfHook ];
    buildInputs = taler-exchange.buildInputs ++ [
      qrencode
      taler-exchange
      # for ltdl.h
      libtool
    ];
    propagatedBuildInputs = [ gnunet ];

    configureFlags = [
      "--with-gnunet=${gnunet}"
      "--with-exchange=${taler-exchange}"
    ];

    enableParallelBuilding = true;

    checkInputs = [ jq ];
    doInstallCheck = true;
    checkTarget = "check";

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
      maintainers = with maintainers; [ astro ];
      platforms = platforms.linux;
    };
  };
}
