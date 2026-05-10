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
  replaceVars,
  systemd,
  udev,
  gnused,
  withApcModbus ? false,
  fetchFromGitHub,
}:
let
  # rebuild libmodbus with downstream usb patches from
  # https://github.com/networkupstools/libmodbus
  # finding the docs for this was actually relatively hard
  # so save them here for reference
  # https://github.com/networkupstools/nut/wiki/APC-UPS-with-Modbus-protocol
  libmodbus' = libmodbus.overrideAttrs (finalAttrs: {
    version = "3.1.11-withUsbRTU-NUT";

    src = fetchFromGitHub {
      owner = "networkupstools";
      repo = "libmodbus";
      rev = "8b9bdcde6938f85415098af74b720b7ad5ed74b4";
      hash = "sha256-ZimIVLKhVjknLNFB+1jGA9N/3YqxHfGX1+l1mpk5im4=";
    };

    buildInputs = [
      libusb1
    ];
  });
  modbus = if withApcModbus then libmodbus' else libmodbus;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "nut";
  version = "2.8.4";

  src = fetchurl {
    url = "https://networkupstools.org/source/${lib.versions.majorMinor finalAttrs.version}/nut-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-ATC6gup58Euk80xSSahZQ5d+/ZhO199q7BpRjVo1lPg=";
  };

  patches = [
    # This patch injects a default value for NUT_CONFPATH into the nutshutdown script
    # since the way we build the package results in the binaries being hardcoded to check
    # $out/etc/ups.conf instead of /etc/nut/ups.conf (where the module places the file).
    # We also cannot use `--sysconfdir=/etc/nut` since that results in the install phase
    # trying to install directly into /etc/nut which predictably fails
    ./nutshutdown-conf-default.patch

    (replaceVars ./hardcode-paths.patch {
      avahi = "${avahi}/lib";
      freeipmi = "${freeipmi}/lib";
      libgpiod = if stdenv.hostPlatform.isLinux then "${libgpiod_1}/lib" else "/homeless-shelter";
      libusb = "${libusb1}/lib";
      neon = "${neon}/lib";
      libmodbus = "${modbus}/lib";
      netsnmp = "${net-snmp.lib}/lib";
    })
  ];

  buildInputs = [
    avahi
    freeipmi
    gd
    libtool
    libusb1
    modbus
    neon
    net-snmp
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    i2c-tools
    libgpiod_1
    udev
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    makeWrapper
  ];

  doInstallCheck = true;
  configureFlags = [
    "--enable-docs-changelog=no" # TODO: add required build deps
    "--with-all"
    "--with-ssl"
    "--without-powerman" # Until we have it ...
    "--with-pynut=app" # avoid attempts to install python modules to python store path
    "--with-systemdsystempresetdir=$(out)/lib/systemd/system-preset"
    "--with-systemdsystemunitdir=$(out)/lib/systemd/system"
    "--with-systemdshutdowndir=$(out)/lib/systemd/system-shutdown"
    "--with-systemdtmpfilesdir=$(out)/lib/tmpfiles.d"
    "--with-udev-dir=$(out)/etc/udev"
    "--with-user=nutmon"
    "--with-group=nutmon"
  ]
  ++ (lib.lists.optionals withApcModbus [
    "--with-modbus+usb"
  ]);

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

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
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

  meta = {
    description = "Network UPS Tools";
    longDescription = ''
      Network UPS Tools is a collection of programs which provide a common
      interface for monitoring and administering UPS, PDU and SCD hardware.
      It uses a layered approach to connect all of the parts.
    '';
    homepage = "https://networkupstools.org/";
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.pierron ];
    license = with lib.licenses; [
      gpl1Plus
      gpl2Plus
      gpl3Plus
    ];
    priority = 10;
  };
})
