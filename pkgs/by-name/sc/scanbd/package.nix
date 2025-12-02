{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  dbus,
  libconfuse,
  libjpeg,
  sane-backends,
  systemd,
}:

let
  # Logical FHS directory paths (without $out prefix)
  systemdSystemUnitDir = "/lib/systemd/system";
  dbusSystemConfigDir = "/share/dbus-1/system.d";
  dbusSystemServicesDir = "/share/dbus-1/system-services";
  udevRulesDir = "/lib/udev/rules.d";
in

stdenv.mkDerivation rec {
  pname = "scanbd";
  version = "1.5.1";

  src = fetchurl {
    sha256 = "0pvy4qirfjdfm8aj6x5rkbgl7hk3jfa2s21qkk8ic5dqfjjab75n";
    url = "mirror://sourceforge/scanbd/${pname}-${version}.tgz";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    dbus
    libconfuse
    libjpeg
    sane-backends
    systemd
  ];

  configureFlags = [
    "--disable-Werror"
    "--enable-udev"
    "--with-systemdsystemunitdir=$out${systemdSystemUnitDir}"
  ]
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    # AC_FUNC_MALLOC is broken on cross builds.
    "ac_cv_func_malloc_0_nonnull=yes"
    "ac_cv_func_realloc_0_nonnull=yes"
  ];

  enableParallelBuilding = true;

  postInstall = ''
    # Install DBUS configuration for scanbm network scanning support
    mkdir -p $out${dbusSystemConfigDir} $out${dbusSystemServicesDir}
    cp integration/scanbd_dbus.conf $out${dbusSystemConfigDir}/
    cp integration/systemd/de.kmux.scanbd.server.service $out${dbusSystemServicesDir}/

    # Install udev rules for automatic scanner detection
    mkdir -p $out${udevRulesDir}
    cp integration/98-snapscan.rules $out${udevRulesDir}/
    cp integration/99-saned.rules $out${udevRulesDir}/
  '';

  postFixup = ''
    # NixOS uses 'scanner' user/group, not 'saned'
    substituteInPlace $out${dbusSystemConfigDir}/scanbd_dbus.conf \
      --replace-fail "saned" "scanner"
    substituteInPlace $out${udevRulesDir}/99-saned.rules \
      --replace-fail "saned" "scanner"

    # Fix logger path in snapscan rules
    substituteInPlace $out${udevRulesDir}/98-snapscan.rules \
      --replace-fail "/usr/bin/logger" "/run/current-system/sw/bin/logger"
  '';

  doCheck = true;

  meta = with lib; {
    description = "Scanner button daemon";
    longDescription = ''
      scanbd polls a scanner's buttons, looking for button presses, function
      knob changes, or other scanner events such as paper inserts and removals,
      while at the same time allowing scan-applications to access the scanner.

      Various actions can be submitted (scan, copy, email, ...) via action
      scripts. The function knob values are passed to the action scripts as
      well. Scan actions are also signaled via dbus. This can be useful for
      foreign applications. Scans can also be triggered via dbus from foreign
      applications.

      On platforms which support signaling of dynamic device insertion/removal
      (libudev, dbus, hal), scanbd supports this as well.

      scanbd can use all sane-backends or some special backends from the (old)
      scanbuttond project.
    '';
    homepage = "http://scanbd.sourceforge.net/";
    downloadPage = "https://sourceforge.net/projects/scanbd/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ csingley ];
  };
}
