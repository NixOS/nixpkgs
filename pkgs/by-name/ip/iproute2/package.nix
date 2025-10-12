{
  lib,
  stdenv,
  fetchurl,
  buildPackages,
  bison,
  flex,
  pkg-config,
  db,
  iptables,
  elfutils,
  libmnl,
  libbpf,
  python3,
  gitUpdater,
  pkgsStatic,
}:

stdenv.mkDerivation rec {
  pname = "iproute2";
  version = "6.17.0";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/net/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-l4HllBCrfeqOn3m7EP8UiOY9EPy7cFA7lEJronqOLew=";
  };

  patches = [
    (fetchurl {
      name = "musl-endian.patch";
      url = "https://lore.kernel.org/netdev/20240712191209.31324-1-contact@hacktivis.me/raw";
      hash = "sha256-MX+P+PSEh6XlhoWgzZEBlOV9aXhJNd20Gi0fJCcSZ5E=";
    })
    (fetchurl {
      name = "musl-basename.patch";
      url = "https://lore.kernel.org/netdev/20240804161054.942439-1-dilfridge@gentoo.org/raw";
      hash = "sha256-47obv6mIn/HO47lt47slpTAFDxiQ3U/voHKzIiIGCTM=";
    })
  ]
  # Temporarily gated to keep rebuild counts under control.
  # The proper fix (targeted to staging) is done in https://github.com/NixOS/nixpkgs/pull/451397
  ++ lib.optionals stdenv.hostPlatform.isMusl [
    (fetchurl {
      name = "musl-redefinition.patch";
      url = "https://lore.kernel.org/netdev/20251012124002.296018-1-yureka@cyberchaos.dev/raw";
      hash = "sha256-8gSpZb/B5sMd2OilUQqg0FqM9y3GZd5Ch5AXV5wrCZQ=";
    })
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace "CC := gcc" "CC ?= $CC"
  '';

  outputs = [
    "out"
    "dev"
    "scripts"
  ];

  configureFlags = [
    "--color"
    "auto"
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "SBINDIR=$(out)/sbin"
    "DOCDIR=$(TMPDIR)/share/doc/${pname}" # Don't install docs
    "HDRDIR=$(dev)/include/iproute2"
  ]
  ++ lib.optionals stdenv.hostPlatform.isStatic [
    "SHARED_LIBS=n"
    # all build .so plugins:
    "TC_CONFIG_NO_XT=y"
  ]
  ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "HOSTCC=$(CC_FOR_BUILD)"
  ];

  buildFlags = [
    "CONFDIR=/etc/iproute2"
  ];

  installFlags = [
    "CONFDIR=$(out)/etc/iproute2"
  ];

  postInstall = ''
    moveToOutput sbin/routel "$scripts"
  '';

  depsBuildBuild = [ buildPackages.stdenv.cc ]; # netem requires $HOSTCC
  nativeBuildInputs = [
    bison
    flex
    pkg-config
  ];
  buildInputs = [
    db
    iptables
    libmnl
    python3
  ]
  # needed to uploaded bpf programs
  ++ lib.optionals (!stdenv.hostPlatform.isStatic) [
    elfutils
    libbpf
  ];

  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    # No nicer place to find latest release.
    url = "https://git.kernel.org/pub/scm/network/iproute2/iproute2.git";
    rev-prefix = "v";
  };
  # needed for nixos-anywhere
  passthru.tests.static = pkgsStatic.iproute2;

  meta = with lib; {
    homepage = "https://wiki.linuxfoundation.org/networking/iproute2";
    description = "Collection of utilities for controlling TCP/IP networking and traffic control in Linux";
    platforms = platforms.linux;
    license = licenses.gpl2Only;
    maintainers = with maintainers; [
      fpletz
      globin
    ];
  };
}
