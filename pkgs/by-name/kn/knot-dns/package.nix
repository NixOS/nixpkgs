{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gnutls,
  liburcu,
  lmdb,
  libcap_ng,
  libidn2,
  libunistring,
  systemd,
  nettle,
  libedit,
  zlib,
  libiconv,
  libintl,
  libmaxminddb,
  libbpf,
  nghttp2,
  libmnl,
  ngtcp2-gnutls,
  xdp-tools,
  fstrm,
  protobufc,
  sphinx,
  autoreconfHook,
  nixosTests,
  knot-resolver,
  knot-dns,
  runCommandLocal,
}:

stdenv.mkDerivation rec {
  pname = "knot-dns";
  version = "3.5.0";

  src = fetchurl {
    url = "https://secure.nic.cz/files/knot-dns/knot-${version}.tar.xz";
    sha256 = "d52538bf7364c280999dec58c2a02a405dd922ef5794da1473ca7c3cf7f01277";
  };

  outputs = [
    "bin"
    "out"
    "dev"
  ];

  configureFlags = [
    "--with-configdir=/etc/knot"
    "--with-rundir=/run/knot"
    "--with-storage=/var/lib/knot"
    "--with-module-dnstap"
    "--enable-dnstap"
  ];

  patches = [
    # Don't try to create directories like /var/lib/knot at build time.
    # They are later created from NixOS itself.
    ./dont-create-run-time-dirs.patch
    ./runtime-deps.patch
  ];

  # FIXME: sphinx is needed for now to get man-pages
  nativeBuildInputs = [
    pkg-config
    protobufc # dnstap support
    autoreconfHook
    sphinx
  ];
  buildInputs = [
    gnutls
    liburcu
    libidn2
    libunistring
    nettle
    libedit
    libiconv
    lmdb
    libintl
    nghttp2 # DoH support in kdig
    ngtcp2-gnutls # DoQ support in kdig (and elsewhere but not much use there yet)
    libmaxminddb # optional for geoip module (it's tiny)
    # without sphinx &al. for developer documentation
    fstrm
    protobufc # dnstap support
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libcap_ng
    systemd
    xdp-tools
    libbpf
    libmnl # XDP support (it's Linux kernel API)
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin zlib; # perhaps due to gnutls

  enableParallelBuilding = true;
  strictDeps = true;

  CFLAGS = [
    "-O2"
    "-DNDEBUG"
  ];

  __darwinAllowLocalNetworking = true;

  doCheck = true;
  checkFlags = [ "V=1" ]; # verbose output in case some test fails
  doInstallCheck = true;

  postInstall = ''
    rm -r "$out"/lib/*.la
  '';

  passthru.tests = {
    inherit knot-resolver;
  }
  // lib.optionalAttrs stdenv.hostPlatform.isLinux {
    inherit (nixosTests) knot kea;
    prometheus-exporter = nixosTests.prometheus-exporters.knot;
    # Some dependencies are very version-sensitive, so the might get dropped
    # or embedded after some update, even if the nixPackagers didn't intend to.
    # For non-linux I don't know a good replacement for `ldd`.
    deps = runCommandLocal "knot-deps-test" { nativeBuildInputs = [ (lib.getBin stdenv.cc.libc) ]; } ''
      for libname in libngtcp2 libxdp libbpf; do
        echo "Checking for $libname:"
        ldd '${knot-dns.bin}/bin/knotd' | grep -F "$libname"
        echo "OK"
      done
      touch "$out"
    '';
  };

  meta = {
    description = "Authoritative-only DNS server from .cz domain registry";
    homepage = "https://knot-dns.cz";
    changelog = "https://gitlab.nic.cz/knot/knot-dns/-/releases/v${version}";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.vcunat ];
    mainProgram = "knotd";
  };
}
