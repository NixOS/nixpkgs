{
  stdenv,
  fetchpatch,
  fetchurl,
  dbus,
  zlib,
  openssl,
  readline,
  lib,
  perl,
}:

stdenv.mkDerivation {
  pname = "wvstreams";
  version = "4.6.1";

  # See https://layers.openembedded.org/layerindex/recipe/190863/
  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/wvstreams/wvstreams-4.6.1.tar.gz";
    hash = "sha256-hAP1+/g6qawMbOFdl/2FYHSIFSqoTgB7fQYhuOvAdjM=";
  };

  patches = [
    (fetchpatch {
      url = "https://cgit.openembedded.org/meta-openembedded/plain/meta-oe/recipes-connectivity/wvdial/wvstreams/04_signed_request.diff?id=0e6c34f82ca4d43cbca3754c5fe37c5b3bdd0f37";
      hash = "sha256-zlPiME+KYjesmKt3a+JoE087qE1MbnlVPjC75qQoIks=";
    })
    (fetchpatch {
      url = "https://cgit.openembedded.org/meta-openembedded/plain/meta-oe/recipes-connectivity/wvdial/wvstreams/05_gcc.diff?id=0e6c34f82ca4d43cbca3754c5fe37c5b3bdd0f37";
      hash = "sha256-Twqk0J8E05kAvhHjAoAuYEpS445t3mb/BvuxTmaaGoM=";
    })
    (fetchpatch {
      url = "https://cgit.openembedded.org/meta-openembedded/plain/meta-oe/recipes-connectivity/wvdial/wvstreams/06_gcc-4.7.diff?id=0e6c34f82ca4d43cbca3754c5fe37c5b3bdd0f37";
      hash = "sha256-JMPNUdfAJ/gq+am/F1DE2q3+35ItiLAve1+LLl8+Oe4=";
    })
    (fetchpatch {
      url = "https://cgit.openembedded.org/meta-openembedded/plain/meta-oe/recipes-connectivity/wvdial/wvstreams/07_buildflags.diff?id=0e6c34f82ca4d43cbca3754c5fe37c5b3bdd0f37";
      hash = "sha256-N3HmuBakD5VHoToOqU6EmTHlgFG6A7x84Gbf2P2u+s8=";
    })
    (fetchpatch {
      url = "https://cgit.openembedded.org/meta-openembedded/plain/meta-oe/recipes-connectivity/wvdial/wvstreams/gcc-6.patch?id=0e6c34f82ca4d43cbca3754c5fe37c5b3bdd0f37";
      hash = "sha256-fXhBUKaHD27mspwrKNY5G7F6UHqq/dmnPlf9cIvM7hM=";
    })
    (fetchpatch {
      url = "https://cgit.openembedded.org/meta-openembedded/plain/meta-oe/recipes-connectivity/wvdial/wvstreams/argp.patch?id=0e6c34f82ca4d43cbca3754c5fe37c5b3bdd0f37";
      hash = "sha256-55vWFfd/SDa9dE+GmSHDMU2kTrn+tNUW2clPknSdi7g=";
    })
    (fetchpatch {
      url = "https://cgit.openembedded.org/meta-openembedded/plain/meta-oe/recipes-connectivity/wvdial/wvstreams/0001-Check-for-limits.h-during-configure.patch?id=0e6c34f82ca4d43cbca3754c5fe37c5b3bdd0f37";
      hash = "sha256-XRJCZMnygcQie9sUc1iCe9HVE9lEFCed4JRDtd/C/84=";
    })
    (fetchpatch {
      url = "https://cgit.openembedded.org/meta-openembedded/plain/meta-oe/recipes-connectivity/wvdial/wvstreams/0003-wvtask-Check-for-HAVE_LIBC_STACK_END-only-on-glibc-s.patch?id=0e6c34f82ca4d43cbca3754c5fe37c5b3bdd0f37";
      hash = "sha256-v0WAFyWwQ70dpq1BEXQjkOrdUUk4tBFJVKeHffs4FmA=";
    })
    (fetchpatch {
      url = "https://cgit.openembedded.org/meta-openembedded/plain/meta-oe/recipes-connectivity/wvdial/wvstreams/0004-wvcrash-Replace-use-of-basename-API.patch?id=0e6c34f82ca4d43cbca3754c5fe37c5b3bdd0f37";
      hash = "sha256-1UZziDaE0BCM/YmYjBgFA2Q8zfnWpQcal08a0qcClmo=";
    })
    (fetchpatch {
      url = "https://cgit.openembedded.org/meta-openembedded/plain/meta-oe/recipes-connectivity/wvdial/wvstreams/0005-check-for-libexecinfo-during-configure.patch?id=0e6c34f82ca4d43cbca3754c5fe37c5b3bdd0f37";
      hash = "sha256-4Ad10pijea/qusrdCJAEjpc1/qfQNE32t/M2YMk5jNg=";
    })
    (fetchpatch {
      url = "https://cgit.openembedded.org/meta-openembedded/plain/meta-oe/recipes-connectivity/wvdial/wvstreams/0001-build-fix-parallel-make.patch?id=0e6c34f82ca4d43cbca3754c5fe37c5b3bdd0f37";
      hash = "sha256-zWREskvLoAH2sYn6kbemTC1V5KrF9jX0B0d+ASExQBA=";
    })
    (fetchpatch {
      url = "https://cgit.openembedded.org/meta-openembedded/plain/meta-oe/recipes-connectivity/wvdial/wvstreams/0002-wvrules.mk-Use-_DEFAULT_SOURCE.patch?id=0e6c34f82ca4d43cbca3754c5fe37c5b3bdd0f37";
      hash = "sha256-ACiuwqwg5nUbzqoJR5h9GENXmN3ELzkBjujZivBoM4g=";
    })
    (fetchpatch {
      url = "https://cgit.openembedded.org/meta-openembedded/plain/meta-oe/recipes-connectivity/wvdial/wvstreams/openssl-buildfix.patch?id=0e6c34f82ca4d43cbca3754c5fe37c5b3bdd0f37";
      hash = "sha256-pMHopuBEge7Llq1Syb8sZJArhUOWBNmcOvVcNtFgnbA=";
    })
    (fetchpatch {
      url = "https://cgit.openembedded.org/meta-openembedded/plain/meta-oe/recipes-connectivity/wvdial/wvstreams/0001-Forward-port-to-OpenSSL-1.1.x.patch?id=0e6c34f82ca4d43cbca3754c5fe37c5b3bdd0f37";
      hash = "sha256-R5pfYxefEvvxB1k+gZzRQgsbmkgpK9cBqZxCXHQnQlM=";
    })
    (fetchpatch {
      url = "https://cgit.openembedded.org/meta-openembedded/plain/meta-oe/recipes-connectivity/wvdial/wvstreams/0001-Fix-narrowing-conversion-error.patch?id=0e6c34f82ca4d43cbca3754c5fe37c5b3bdd0f37";
      hash = "sha256-esCD7jMVxD1sC2C4jx+pnnIWHpXAVGF/CGXvwHc9rhU=";
    })
  ];

  outputs = [
    "bin"
    "dev"
    "lib"
    "out"
  ];

  enableParallelBuilding = true;

  buildInputs = [
    dbus
    zlib
    openssl
    readline
    perl
  ];

  meta = {
    description = "Network programming library in C++";
    homepage = "http://alumnit.ca/wiki/index.php?page=WvStreams";
    license = lib.licenses.lgpl2;
    maintainers = [ lib.maintainers.flokli ];
    platforms = lib.platforms.linux;
  };
}
