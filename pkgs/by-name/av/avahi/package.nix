{
  fetchFromGitHub,
  lib,
  stdenv,
  pkg-config,
  libdaemon,
  dbus,
  libpcap,
  expat,
  gettext,
  glib,
  autoconf-archive,
  autoreconfHook,
  libiconv,
  libevent,
  nixosTests,
  gtk3Support ? false,
  gtk3,
  qt5,
  qt5Support ? false,
  withLibdnssdCompat ? false,
  python ? null,
  withPython ? false,
  systemdLibs,
  xmltoman,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "avahi${lib.optionalString withLibdnssdCompat "-compat"}";
  version = "0.9-rc5";

  src = fetchFromGitHub {
    owner = "avahi";
    repo = "avahi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ps3FcDI6B0S+ENw7EJQzqSxVCeYUmq5Q/XFrnLEIyUc=";
  };

  outputs = [
    "out"
    "dev"
    "man"
  ];

  postPatch = ''
    # Remove the vendored ACX_PTHREAD macro in favor of the more up-to-date
    # implementation from autoconf-archive, especially to support static builds.
    rm common/acx_pthread.m4
  '';

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    pkg-config
    gettext
    glib
    autoconf-archive
    autoreconfHook
    xmltoman
  ];

  buildInputs = [
    libdaemon
    dbus
    glib
    expat
    libiconv
    libevent
    systemdLibs
  ]
  ++ lib.optionals stdenv.hostPlatform.isFreeBSD [
    libpcap
  ]
  ++ lib.optionals gtk3Support [
    gtk3
  ]
  ++ lib.optionals qt5Support [
    qt5
  ];

  propagatedBuildInputs = lib.optionals withPython (
    with python.pkgs;
    [
      python
      pygobject3
      dbus-python
    ]
  );

  configureFlags = [
    "--disable-gdbm"
    "--disable-mono"
    # Use non-deprecated path https://github.com/avahi/avahi/pull/376
    "--with-dbus-sys=${placeholder "out"}/share/dbus-1/system.d"
    (lib.enableFeature gtk3Support "gtk3")
    (lib.enableFeature qt5Support "qt5")
    (lib.enableFeature withPython "python")
    "--localstatedir=/var"
    "--runstatedir=/run"
    "--sysconfdir=/etc"
    "--with-distro=${with stdenv.hostPlatform; if isBSD then parsed.kernel.name else "none"}"
    # A systemd unit is provided by the avahi-daemon NixOS module
    "--with-systemdsystemunitdir=no"
  ]
  ++ lib.optionals withLibdnssdCompat [
    "--enable-compat-libdns_sd"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # autoipd won't build on darwin
    "--disable-autoipd"
  ];

  installFlags = [
    # Override directories to install into the package.
    "runstatedir=${placeholder "out"}/run"
    "sysconfdir=${placeholder "out"}/etc"
  ];

  preBuild = lib.optionalString stdenv.hostPlatform.isDarwin ''
    sed -i '20 i\
    #define __APPLE_USE_RFC_2292' \
    avahi-core/socket.c
  '';

  postInstall =
    # Maintain compat for mdnsresponder
    lib.optionalString withLibdnssdCompat ''
      ln -s avahi-compat-libdns_sd/dns_sd.h "$dev/include/dns_sd.h"
    '';

  enableParallelBuilding = true;

  passthru.tests = {
    smoke-test = nixosTests.avahi;
    smoke-test-resolved = nixosTests.avahi-with-resolved;
  };

  meta = {
    description = "mDNS/DNS-SD implementation";
    homepage = "http://avahi.org";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = [
    ];

    longDescription = ''
      Avahi is a system which facilitates service discovery on a local
      network.  It is an implementation of the mDNS (for "Multicast
      DNS") and DNS-SD (for "DNS-Based Service Discovery")
      protocols.
    '';
  };
})
