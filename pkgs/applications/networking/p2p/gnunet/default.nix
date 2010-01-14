{ stdenv, fetchurl, libextractor, libmicrohttpd, libgcrypt
, zlib, gmp, curl, libtool, guile, adns, sqlite, pkgconfig
, libxml2, ncurses, gettext, findutils
, gtkSupport ? false, gtk ? null, libglade ? null
, makeWrapper }:

assert gtkSupport -> (gtk != null) && (libglade != null);

let version = "0.8.1";
in
  stdenv.mkDerivation {
    name = "gnunet-${version}";

    src = fetchurl {
      url = "mirror://gnu/gnunet/GNUnet-${version}.tar.gz";
      sha256 = "0makh52fsrsxg2qgfi1n68sh2hllqxj453g335m05wk05d7minl4";
    };

    buildInputs = [
      libextractor libmicrohttpd libgcrypt gmp curl libtool
      zlib guile adns sqlite libxml2 ncurses
      pkgconfig gettext findutils
      makeWrapper
    ] ++ (if gtkSupport then [ gtk libglade ] else []);

    preConfigure = ''
      # Brute force: since nix-worker chroots don't provide
      # /etc/{resolv.conf,hosts}, replace all references to `localhost'
      # by their IPv4 equivalent.
      for i in $(find . \( -name \*.c -or -name \*.conf \) \
                      -exec grep -l localhost {} \;)
      do
        echo "$i: substituting \`127.0.0.1' to \`localhost'..."
        substituteInPlace "$i" --replace "localhost" "127.0.0.1"
      done

      # Make sure the tests don't rely on `/tmp', for the sake of chroot
      # builds.
      for i in $(find . \( -iname \*test\*.c -or -name \*.conf \) \
                      -exec grep -l /tmp {} \;)
      do
        echo "$i: replacing references to \`/tmp' by \`$TMPDIR'..."
        substituteInPlace "$i" --replace "/tmp" "$TMPDIR"
      done
    '';

    doCheck = false;

    # 1. Run tests have once GNUnet is installed.
    # 2. Help programs find the numerous modules that sit under
    #    `$out/lib/GNUnet'.

    # FIXME: `src/transports/test_udp' hangs forever.
    postInstall = ''
      #GNUNET_PREFIX="$out" make check
      wrapProgram "$out/bin/gnunetd" \
        --prefix LTDL_LIBRARY_PATH ":" "$out/lib/GNUnet"
    '';

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

      maintainers = [ stdenv.lib.maintainers.ludo ];
      platforms = stdenv.lib.platforms.gnu;
    };
  }
