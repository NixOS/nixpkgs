{ stdenv, fetchgit, libextractor, libmicrohttpd, libgcrypt
, zlib, gmp, curl, libtool, adns, sqlite, pkgconfig
, libxml2, ncurses, gettext, libunistring, libidn
, makeWrapper, autoconf, automake, texinfo, which
, withVerbose ? false }:

let
  rev = 	"ce2864cfaa27e55096b480bf35db5f8cee2a5e7e";
in
stdenv.mkDerivation {
  name = "gnunet-git-${rev}";

  src = fetchgit {
    url =  https://gnunet.org/git/gnunet.git;
    inherit rev;
    sha256 = "0gbw920m9v4b3425c0d1h7drgl2m1fni1bwjn4fwqnyz7kdqzsgl";
  };

  buildInputs = [
    libextractor libmicrohttpd libgcrypt gmp curl libtool
    zlib adns sqlite libxml2 ncurses libidn
    pkgconfig gettext libunistring makeWrapper
    autoconf automake texinfo which
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

  meta = with stdenv.lib; {
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

    homepage = https://gnunet.org/;

    license = licenses.agpl3Plus;

    maintainers = with stdenv.lib.maintainers; [ ];
    platforms = platforms.gnu ++ platforms.linux;
  };
}
