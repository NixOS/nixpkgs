{
  lib,
  stdenv,
  fetchurl,

  # build-time deps
  libtool,
  makeWrapper,
  meson,
  ninja,
  pkg-config,

  # runtime deps
  adns,
  curl,
  gettext,
  gmp,
  gnutls,
  jansson,
  libextractor,
  libgcrypt,
  libgnurl,
  libidn,
  libmicrohttpd,
  libogg,
  libopus,
  libpulseaudio,
  libsodium,
  libunistring,
  libxml2,
  ncurses,
  sqlite,
  zlib,

  postgresqlSupport ? true,
  libpq,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnunet";
  version = "0.24.0";

  src = fetchurl {
    url = "mirror://gnu/gnunet/gnunet-${finalAttrs.version}.tar.gz";
    hash = "sha256-BoUvn0gz5ssGvu3fhyerlMQ4U69yOnY4etdxYS4WPFc=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    libtool
    makeWrapper
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    adns
    curl
    gettext
    gmp
    gnutls
    jansson
    libextractor
    libgcrypt
    libgnurl
    libidn
    libmicrohttpd
    libogg
    libopus
    libpulseaudio
    libsodium
    libunistring
    libxml2
    ncurses
    sqlite
    zlib
  ] ++ lib.optional postgresqlSupport libpq;

  preConfigure = ''
    # Brute force: since nix-worker chroots don't provide
    # /etc/{resolv.conf,hosts}, replace all references to `localhost'
    # by their IPv4 equivalent.
    find . \( -name \*.c -or -name \*.conf \) | \
      xargs sed -i -e 's|\<localhost\>|127.0.0.1|g'

    # Make sure the tests don't rely on `/tmp', for the sake of chroot
    # builds.
    find . \( -iname \*test\*.c -or -name \*.conf \) | \
      xargs sed -i -e "s|/tmp|$TMPDIR|g"
  '';

  # unfortunately, there's still a few failures with impure tests
  doCheck = false;
  checkPhase = ''
    export GNUNET_PREFIX="$out"
    export PATH="$out/bin:$PATH"
    make -k check
  '';

  meta = {
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

    homepage = "https://gnunet.org/";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ pstn ];
    platforms = lib.platforms.unix;
    changelog = "https://git.gnunet.org/gnunet.git/tree/ChangeLog?h=v${finalAttrs.version}";
  };
})
