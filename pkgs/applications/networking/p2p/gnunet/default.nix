{ stdenv, fetchurl, adns, curl, gettext, gmp, gnutls, libextractor
, libgcrypt, libgnurl, libidn, libmicrohttpd, libtool, libunistring
, makeWrapper, ncurses, pkgconfig, libxml2, sqlite, zlib
, libpulseaudio, libopus, libogg }:

stdenv.mkDerivation rec {
  name = "gnunet-0.10.1";

  src = fetchurl {
    url = "mirror://gnu/gnunet/${name}.tar.gz";
    sha256 = "04wxzm3wkgqbn42b8ksr4cx6m5cckyig5cls1adh0nwdczwvnp7n";
  };

  buildInputs = [
    adns curl gettext gmp gnutls libextractor libgcrypt libgnurl libidn
    libmicrohttpd libtool libunistring libxml2 makeWrapper ncurses
    pkgconfig sqlite zlib libpulseaudio libopus libogg
  ];

  preConfigure = ''
    # Brute force: since nix-worker chroots don't provide
    # /etc/{resolv.conf,hosts}, replace all references to `localhost'
    # by their IPv4 equivalent.
    find . \( -name \*.c -or -name \*.conf \) | \
      xargs sed -ie 's|\<localhost\>|127.0.0.1|g'

    # Make sure the tests don't rely on `/tmp', for the sake of chroot
    # builds.
    find . \( -iname \*test\*.c -or -name \*.conf \) | \
      xargs sed -ie "s|/tmp|$TMPDIR|g"

    # Ensure NSS installation works fine
    configureFlags="$configureFlags --with-nssdir=$out/lib"
    patchShebangs src/gns/nss/install-nss-plugin.sh

    sed -ie 's|@LDFLAGS@|@LDFLAGS@ $(Z_LIBS)|g' \
      src/regex/Makefile.in \
      src/fs/Makefile.in
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
    description = "GNU's decentralized anonymous and censorship-resistant P2P framework";

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

    license = licenses.gpl2Plus;

    maintainers = with maintainers; [ viric vrthra ];
    platforms = platforms.gnu;
  };
}
