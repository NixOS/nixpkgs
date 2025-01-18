{
  lib,
  stdenv,
  autoreconfHook,
  avahi,
  coreutils,
  fetchurl,
  freeipmi,
  gd,
  i2c-tools,
  libgpiod_1,
  libmodbus,
  libtool,
  libusb1,
  makeWrapper,
  neon,
  net-snmp,
  openssl,
  pkg-config,
  substituteAll,
  systemd,
  udev,
  gnused,
}:

stdenv.mkDerivation rec {
  pname = "nut";
  version = "2.8.2";

  src = fetchurl {
    url = "https://networkupstools.org/source/${lib.versions.majorMinor version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-5LSwy+fdObqQl75/fXh7sv/74132Tf9Ttf45PWWcWX0=";
  };

  patches = [
    # This patch injects a default value for NUT_CONFPATH into the nutshutdown script
    # since the way we build the package results in the binaries being hardcoded to check
    # $out/etc/ups.conf instead of /etc/nut/ups.conf (where the module places the file).
    # We also cannot use `--sysconfdir=/etc/nut` since that results in the install phase
    # trying to install directly into /etc/nut which predictably fails
    ./nutshutdown-conf-default.patch

    (substituteAll {
      src = ./hardcode-paths.patch;
      avahi = "${avahi}/lib";
      freeipmi = "${freeipmi}/lib";
      libgpiod = "${libgpiod_1}/lib";
      libusb = "${libusb1}/lib";
      neon = "${neon}/lib";
      libmodbus = "${libmodbus}/lib";
      netsnmp = "${net-snmp.lib}/lib";
    })
  ];

  buildInputs = [
    neon
    libusb1
    openssl
    udev
    avahi
    freeipmi
    libgpiod_1
    libmodbus
    libtool
    i2c-tools
    net-snmp
    gd
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    makeWrapper
  ];

  configureFlags = [
    "--with-all"
    "--with-ssl"
    "--without-powerman" # Until we have it ...
    "--with-systemdsystemunitdir=$(out)/lib/systemd/system"
    "--with-systemdshutdowndir=$(out)/lib/systemd/system-shutdown"
    "--with-systemdtmpfilesdir=$(out)/lib/tmpfiles.d"
    "--with-udev-dir=$(out)/etc/udev"
  ];

  enableParallelBuilding = true;

  # Add `cgi-bin` to the default list to avoid pulling in whole
  # of `gcc` into build closure.
  stripDebugList = [
    "cgi-bin"
    "lib"
    "lib32"
    "lib64"
    "libexec"
    "bin"
    "sbin"
  ];

  postInstall = ''
    substituteInPlace $out/lib/systemd/system-shutdown/nutshutdown \
      --replace /bin/sed "${gnused}/bin/sed" \
      --replace /bin/sleep "${coreutils}/bin/sleep" \
      --replace /bin/systemctl "${systemd}/bin/systemctl"

    for file in system/{nut-monitor.service,nut-driver-enumerator.service,nut-server.service,nut-driver@.service} system-shutdown/nutshutdown; do
      substituteInPlace $out/lib/systemd/$file \
        --replace "$out/etc/nut.conf" "/etc/nut/nut.conf"
    done

    substituteInPlace $out/lib/systemd/system/nut-driver-enumerator.path \
      --replace "$out/etc/ups.conf" "/etc/nut/ups.conf"

    # Suspicious/overly broad rule, remove it until we know better
    rm $out/etc/udev/rules.d/52-nut-ipmipsu.rules
  '';

  meta = with lib; {
    description = "Network UPS Tools";
    longDescription = ''
      Network UPS Tools is a collection of programs which provide a common
      interface for monitoring and administering UPS, PDU and SCD hardware.
      It uses a layered approach to connect all of the parts.
    '';
    homepage = "https://networkupstools.org/";
    platforms = platforms.linux;
    maintainers = [ maintainers.pierron ];
    license = with licenses; [
      gpl1Plus
      gpl2Plus
      gpl3Plus
    ];
    priority = 10;
  };
}
