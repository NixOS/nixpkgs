{ stdenv, fetchsvn, libextractor, libmicrohttpd, libgcrypt
, zlib, gmp, curl, libtool, adns, sqlite, pkgconfig
, libxml2, ncurses, gettext, libunistring, libidn
, makeWrapper, autoconf, automake
, withVerbose ? false }:

let
  rev = "27775";
in
stdenv.mkDerivation rec {
  name = "gnunet-svn-${rev}";

  src = fetchsvn {
    url =  https://gnunet.org/svn/gnunet;
    inherit rev;
    sha256 = "1fa2g63rrn0mmim9v62gnm2hqr556mbcafb7cs7afycbinix4spf";
  };

  buildInputs = [
    libextractor libmicrohttpd libgcrypt gmp curl libtool
    zlib adns sqlite libxml2 ncurses libidn
    pkgconfig gettext libunistring makeWrapper
    autoconf automake
  ];

  configureFlags = stdenv.lib.optional withVerbose "--enable-logging=verbose ";

  preConfigure = ''
    # Brute force: since nix-worker chroots don't provide
    # /etc/{resolv.conf,hosts}, replace all references to `localhost'
    # by their IPv4 equivalent.
    for i in $(find . \( -name \*.c -or -name \*.conf \) \
                    -exec grep -l '\<localhost\>' {} \;)
    do
      echo "$i: substituting \`127.0.0.1' to \`localhost'..."
      sed -i "$i" -e's/\<localhost\>/127.0.0.1/g'
    done

    # Make sure the tests don't rely on `/tmp', for the sake of chroot
    # builds.
    for i in $(find . \( -iname \*test\*.c -or -name \*.conf \) \
                    -exec grep -l /tmp {} \;)
    do
      echo "$i: replacing references to \`/tmp' by \`$TMPDIR'..."
      substituteInPlace "$i" --replace "/tmp" "$TMPDIR"
    done

    # Ensure NSS installation works fine
    configureFlags="$configureFlags --with-nssdir=$out/lib"
    patchShebangs src/gns/nss/install-nss-plugin.sh

    sh contrib/pogen.sh
    sh bootstrap
  '';

  doCheck = false;

  /* FIXME: Tests must be run this way, but there are still a couple of
     failures.

  postInstall =
    '' export GNUNET_PREFIX="$out"
       export PATH="$out/bin:$PATH"
       make -k check
    '';
  */

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

    maintainers = with stdenv.lib.maintainers; [ ludo viric ];
    platforms = stdenv.lib.platforms.gnu;
  };
}
