{ stdenv, fetchurl, libextractor, libmicrohttpd, libgcrypt
, zlib, gmp, curl, libtool, guile, adns, sqlite, pkgconfig
, libxml2, ncurses, gettext, findutils
, gtkSupport ? false, gtk ? null, libglade ? null }:

assert gtkSupport -> (gtk != null) && (libglade != null);

let version = "0.8.0b";
in
  stdenv.mkDerivation {
    name = "gnunet-${version}";

    src = fetchurl {
      url = "http://gnunet.org/download/GNUnet-${version}.tar.bz2";
      sha256 = "1d1abnfqbd1f8pjzq9p0za7jyy2lay7k8l09xadk83k8d96abwcs";
    };

    configureFlags = ''
      --without-included-ltdl --disable-ltdl-install --with-ltdl-include=${libtool}/include --with-ltdl-lib=${libtool}/lib
    '';

    buildInputs = [
      libextractor libmicrohttpd libgcrypt gmp curl libtool
      zlib guile adns sqlite libxml2 ncurses
      pkgconfig gettext findutils
    ] ++ (if gtkSupport then [ gtk libglade ] else []);

    patches = [
      ./tmpdir.patch
      ./disable-http-tests.patch
    ];

    preConfigure = ''
      # Brute force: make sure the tests don't rely on `/tmp', for
      # the sake of chroot builds.
      for i in $(find . \( -iname \*test\*.c -or -name \*.conf \) \
                      -exec grep -l /tmp {} \;)
      do
        echo "$i: replacing references to \`/tmp' by \`$TMPDIR'..."
        substituteInPlace "$i" --replace "/tmp" "$TMPDIR"
      done
    '';

    # Tests have to be run xonce it's installed.
    # FIXME: Re-enable tests when they are less broken.
    #postInstall = ''
    #  GNUNET_PREFIX="$out" make check
    #'';

    doCheck = false;

    meta = {
      description = "GNUnet, GNU's decentralized anonymous and censorship-resistant P2P framework";

      longDescription = ''
        GNUnet is a framework for secure peer-to-peer networking that
        does not use any centralized or otherwise trusted services.  A
        first service implemented on top of the networking layer
        allows anonymous censorship-resistant file-sharing.  Anonymity
        is provided by making messages originating from a peer
        indistinguishable from messages that the peer is routing.  All
        peers act as routers and use link-encrypted connections with
        stable bandwidth utilization to communicate with each other.
        GNUnet uses a simple, excess-based economic model to allocate
        resources.  Peers in GNUnet monitor each others behavior with
        respect to resource usage; peers that contribute to the
        network are rewarded with better service.
      '';

      homepage = http://gnunet.org/;

      license = "GPLv2+";
    };
  }
