{ stdenv, fetchsvn, libextractor, libmicrohttpd, libgcrypt
, zlib, gmp, curl, libtool, adns, sqlite, pkgconfig
, libxml2, ncurses, gettext, findutils
, autoconf, automake
, gtkSupport ? false, gtk ? null, libglade ? null
, makeWrapper }:

assert gtkSupport -> (gtk != null) && (libglade != null);

let
  rev = "16910";
  version = "0.9-svn-${rev}";
in
  stdenv.mkDerivation {
    name = "gnunet-${version}";

    src = fetchsvn {
      url = "https://gnunet.org/svn/gnunet";
      sha256 = "1jxvh3wvhss0pn286p848zifc8f9pkhcb12m2bpkssh409wwyzkd";
      inherit rev;
    };

    buildInputs = [
      libextractor libmicrohttpd libgcrypt gmp curl libtool
      zlib adns sqlite libxml2 ncurses
      pkgconfig gettext findutils
      autoconf automake
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

      autoreconf -vfi
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
