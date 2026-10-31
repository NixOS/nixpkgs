{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  pythonSupport ? true,
  python3,
  bluetoothSupport ? stdenv.hostPlatform.isLinux,
  bluez,
  tclSupport ? true,
  tcl,
  acl,
  polkitSupport ? lib.meta.availableOn stdenv.hostPlatform polkit,
  polkit,
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

stdenv.mkDerivation (finalAttrs: {
  pname = "brltty";
  version = "6.9.1";

  src = fetchurl {
    url = "https://brltty.app/archive/brltty-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-gi3iyHtECf3wLWFU0bRoVsNTnT6onGWu80MPJ3Nnf3Y=";
  };

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    tcl # One of the build scripts requires tclsh, regardless of tclSupport
    udevCheckHook
  ]
  ++ lib.optionals pythonSupport [
    python3.pkgs.cython
    python3.pkgs.setuptools
  ];
  buildInputs = [
    ncurses.dev
  ]
  ++ lib.optional alsaSupport alsa-lib
  ++ lib.optional bluetoothSupport bluez
  ++ lib.optional polkitSupport polkit
  ++ lib.optional systemdSupport systemdMinimal
  ++ lib.optional tclSupport tcl; # For TCL bindings

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
    "SYSTEMD_UNITS_DIRECTORY=$(out)/lib/systemd/system"
    "SYSTEMD_USERS_DIRECTORY=$(out)/lib/sysusers.d"
    "SYSTEMD_FILES_DIRECTORY=$(out)/lib/tmpfiles.d"
    "UDEV_PARENT_LOCATION=$(out)/lib"
    "INSTALL_COMMANDS_DIRECTORY=$(out)/libexec/brltty"
    "UDEV_RULES_TYPE=all"
    "POLKIT_POLICY_DIR=$(out)/share/polkit-1/actions"
    "POLKIT_RULE_DIR=$(out)/share/polkit-1/rules.d"
  ]
  ++ lib.optional pythonSupport "PYTHON_PREFIX=$(out)"
  ++ lib.optional tclSupport "TCL_DIR=$(out)/lib";
  configureFlags = [
    "--with-writable-directory=/run/brltty"
    "--with-updatable-directory=/var/lib/brltty"
    "--with-api-socket-path=/var/lib/BrlAPI"
    (lib.enableFeature polkitSupport "polkit")
    (lib.enableFeature pythonSupport "python-bindings")
    (lib.enableFeature tclSupport "tcl-bindings")
    (lib.withFeature bluetoothSupport "bluetooth-package")
  ];

  # latex-access is an executable contraction table implemented in Python, so
  # it cannot work without Python — and shipping it would keep a reference to
  # python3 (~200 MiB) in the closure of an otherwise Python-free build.
  postFixup = lib.optionalString (!pythonSupport) ''
    rm -f $out/etc/brltty/Contraction/latex-access.ctb
  '';

  # Enforce the "Python-free closure" guarantee above: if a future upstream
  # table (or a rename of latex-access.ctb) reintroduces a python3 reference,
  # fail the build rather than silently pulling ~200 MiB back in.
  disallowedReferences = lib.optionals (!pythonSupport) [ python3 ];
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
      substituteInPlace udev/rules.d/90-brltty-beeper.rules \
        --replace '/usr/bin/setfacl' '${acl}/bin/setfacl'
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
})
