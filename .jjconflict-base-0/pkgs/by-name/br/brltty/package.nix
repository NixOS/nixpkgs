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
  systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemd,
  systemd,
}:

stdenv.mkDerivation rec {
  pname = "brltty";
  version = "6.6";

  src = fetchurl {
    url = "https://brltty.app/archive/brltty-${version}.tar.gz";
    sha256 = "E+j2mb8UTuGx6PkAOt03hQkvf1XvEHxJEuPBT2zMpPw=";
  };

  nativeBuildInputs = [
    pkg-config
    python3.pkgs.cython
    python3.pkgs.setuptools
    tcl
  ];
  buildInputs = [ bluez ] ++ lib.optional alsaSupport alsa-lib ++ lib.optional systemdSupport systemd;

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

  preConfigure = ''
    substituteInPlace configure --replace /sbin/ldconfig ldconfig

    # Some script needs a working tclsh shebang
    patchShebangs .

    # Skip impure operations
    substituteInPlace Programs/Makefile.in    \
      --replace install-writable-directory "" \
      --replace install-apisoc-directory ""   \
      --replace install-api-key ""
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
       --replace 'udevadm' "${systemd}/bin/udevadm"
  '';
}
