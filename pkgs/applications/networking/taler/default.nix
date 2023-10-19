{ lib, stdenv, fetchgit, curl, gnunet, jansson, libgcrypt, libmicrohttpd_0_9_72
, qrencode, libsodium, libtool, libunistring, pkg-config, postgresql
, autoreconfHook, python39, recutils, wget, jq, gettext, texinfo
}:

let
  version = "0.9.2";

  taler-wallet-core = fetchgit {
    url = "https://git.taler.net/wallet-core.git";
    rev = "v${version}";
    sha256 = "sha256-DTnwj/pkowR1b1+N94pnuLykD2O37Nh8AKhUIzY7NaU=";
  };

in rec {
  taler-exchange = stdenv.mkDerivation rec {
    pname = "taler-exchange";
    inherit version;

    src = fetchgit {
      url = "https://git.taler.net/exchange.git";
      rev = "v${version}";
      fetchSubmodules = true;
      sha256 = "sha256-c0cX38hDIZGVhHrD9LgDU70dF2AYuZmsakC8yDyZE54=";
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

    preConfigure = ''
      ./contrib/gana-update.sh
    '';

    enableParallelBuilding = true;

    nativeCheckInputs = [ wget curl ];
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
    inherit version;

    src = fetchgit {
      url = "https://git.taler.net/merchant.git";
      rev = "v${version}";
      sha256 = "sha256-NPK8yhuTtZZiWE7OsUMdlb2aycegPzRFud41xHE9IL8=";
    };
    postUnpack = ''
      ln -s ${taler-wallet-core}/spa.html $sourceRoot/contrib/
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

    nativeCheckInputs = [ jq ];
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
