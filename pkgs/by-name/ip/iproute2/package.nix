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
  version = "6.18.0";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/net/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-a6Ug4ZdeTFDckx7q6R6jfBmLihc3RIhfiJW4QyX51FY=";
  };

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
