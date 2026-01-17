{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  python3,
  bluez,
  tcl,
  acl,
  kmod,
  coreutils,
  shadow,
  util-linux,
  alsaSupport ? stdenv.hostPlatform.isLinux,
  alsa-lib,
  systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemdMinimal,
  systemdMinimal,
  ncurses,
  udevCheckHook,
  buildPackages,
}:

stdenv.mkDerivation rec {
  pname = "brltty";
  version = "6.8";

  src = fetchurl {
    url = "https://brltty.app/archive/brltty-${version}.tar.gz";
    sha256 = "sha256-MoDYjHU6aJY9e5cgjm9InOEDGCs+jvlEurMWg9wo4RY=";
  };

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    python3.pkgs.cython
    python3.pkgs.setuptools
    tcl # One of build scripts require tclsh
    udevCheckHook
  ];
  buildInputs = [
    bluez
    ncurses.dev
    tcl # For TCL bindings
  ]
  ++ lib.optional alsaSupport alsa-lib
  ++ lib.optional systemdSupport systemdMinimal;

  doInstallCheck = true;

  meta = {
    description = "Access software for a blind person using a braille display";
    longDescription = ''
      BRLTTY is a background process (daemon) which provides access to the Linux/Unix
      console (when in text mode) for a blind person using a refreshable braille display.
      It drives the braille display, and provides complete screen review functionality.
      Some speech capability has also been incorporated.
    '';
    homepage = "https://brltty.app";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.bramd ];
    platforms = lib.platforms.all;
  };

  makeFlags = [
    "PYTHON_PREFIX=$(out)"
    "SYSTEMD_UNITS_DIRECTORY=$(out)/lib/systemd/system"
    "SYSTEMD_USERS_DIRECTORY=$(out)/lib/sysusers.d"
    "SYSTEMD_FILES_DIRECTORY=$(out)/lib/tmpfiles.d"
    "UDEV_PARENT_LOCATION=$(out)/lib"
    "INSTALL_COMMANDS_DIRECTORY=$(out)/libexec/brltty"
    "UDEV_RULES_TYPE=all"
    "POLKIT_POLICY_DIR=$(out)/share/polkit-1/actions"
    "POLKIT_RULE_DIR=$(out)/share/polkit-1/rules.d"
    "TCL_DIR=$(out)/lib"
  ];
  configureFlags = [
    "--with-writable-directory=/run/brltty"
    "--with-updatable-directory=/var/lib/brltty"
    "--with-api-socket-path=/var/lib/BrlAPI"
  ];
  installFlags = [
    "install-systemd"
    "install-udev"
    "install-polkit"
  ];

  env = lib.optionalAttrs (stdenv.hostPlatform != stdenv.buildPlatform) {
    # Build platform compilers for mk4build and second pass of ./configure
    CC_FOR_BUILD = "${buildPackages.stdenv.cc}/bin/${buildPackages.stdenv.cc.targetPrefix}cc";
  };

  preConfigure = ''
    substituteInPlace configure --replace-fail "/sbin/ldconfig -n" "true"

    # Some script needs a working tclsh shebang
    patchShebangs .

    # Skip impure operations
    substituteInPlace Programs/Makefile.in    \
      --replace-fail install-apisoc-directory ""   \
      --replace-fail install-api-key ""
  ''
  + lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    # ./configure call itself second time for build platform, if it fail -- it fails silently, make it visible
    # (this is not mandatory changing, but make further maintaining easier)
    substituteInPlace mk4build \
      --replace-fail "--quiet" ""
    # Respect targetPrefix when invoking ar
    substituteInPlace Programs/Makefile.in \
      --replace-fail "ar " "$AR "
  '';

  postInstall = ''
    # Rewrite absolute paths
    substituteInPlace $out/bin/brltty-mkuser \
      --replace '/sbin/nologin' '${shadow}/bin/nologin'
    (
      cd $out/lib
      substituteInPlace systemd/system/brltty@.service \
        --replace '/sbin/modprobe' '${kmod}/bin/modprobe'
      # Ensure the systemd-wrapper script uses the correct path to the brltty binary
      sed "/^Environment=\"BRLTTY_EXECUTABLE_ARGUMENTS.*/a Environment=\"BRLTTY_EXECUTABLE_PATH=$out/bin/brltty\"" -i systemd/system/brltty@.service
      substituteInPlace systemd/system/brltty-device@.service \
        --replace '/usr/bin/true' '${coreutils}/bin/true'
      substituteInPlace udev/rules.d/90-brltty-uinput.rules \
        --replace '/usr/bin/setfacl' '${acl}/bin/setfacl'
      substituteInPlace udev/rules.d/90-brltty-hid.rules \
        --replace '/usr/bin/setfacl' '${acl}/bin/setfacl'
       substituteInPlace tmpfiles.d/brltty.conf \
        --replace "$out/etc" '/etc'

      # Remove unused commands from udev rules
      sed '/initctl/d' -i udev/rules.d/90-brltty-usb-generic.rules
      sed '/initctl/d' -i udev/rules.d/90-brltty-usb-customized.rules
      # Remove pulse-access group from systemd unit and sysusers
      substituteInPlace systemd/system/brltty@.service \
        --replace 'SupplementaryGroups=pulse-access' '# SupplementaryGroups=pulse-access'
      substituteInPlace sysusers.d/brltty.conf \
        --replace 'm brltty pulse-access' '# m brltty pulse-access'
     )
     substituteInPlace $out/libexec/brltty/systemd-wrapper \
       --replace 'logger' "${util-linux}/bin/logger" \
       --replace 'udevadm' "${systemdMinimal}/bin/udevadm"
  '';
}
