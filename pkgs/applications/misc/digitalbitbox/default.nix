{
  mkDerivation,
  lib,
  autoreconfHook,
  curl,
  fetchFromGitHub,
  git,
  libevent,
  libtool,
  qrencode,
  udev,
  libusb1,
  makeWrapper,
  pkg-config,
  qtbase,
  qttools,
  qtwebsockets,
  qtmultimedia,
  udevRule51 ? ''
    SUBSYSTEM=="usb", TAG+="uaccess", TAG+="udev-acl", SYMLINK+="dbb%n", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2402"
  '',
  udevRule52 ? ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2402", TAG+="uaccess", TAG+="udev-acl", SYMLINK+="dbbf%n"
  '',
  udevCheckHook,
  writeText,
}:

# Enabling the digitalbitbox program
#
#     programs.digitalbitbox.enable = true;
#
# will install the digitalbitbox package and enable the corresponding hardware
# module and is by far the easiest way to get started with the Digital Bitbox on
# NixOS.

# In case you install the package only, please be aware that you may need to
# apply some udev rules to allow the application to identify and access your
# wallet. In a nixos-configuration, one may accomplish this by enabling the
# digitalbitbox hardware module
#
#     hardware.digitalbitbox.enable = true;
#
# or by adding the digitalbitbox package to system.udev.packages
#
#     system.udev.packages = [ pkgs.digitalbitbox ];

# See https://digitalbitbox.com/start_linux for more information.
let
  copyUdevRuleToOutput = name: rule: "cp ${writeText name rule} $out/etc/udev/rules.d/${name}";
in
mkDerivation rec {
  pname = "digitalbitbox";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "digitalbitbox";
    repo = "dbb-app";
    rev = "v${version}";
    sha256 = "ig3+TdYv277D9GVnkRSX6nc6D6qruUOw/IQdQCK6FoA=";
  };

  # configure.ac:23: error: AC_CONFIG_MACRO_DIR can only be used once
  postPatch = ''
    sed -i "23d" src/hidapi/configure.ac
  '';

  nativeBuildInputs = [
    autoreconfHook
    curl
    git
    makeWrapper
    pkg-config
    qttools
    udevCheckHook
  ];

  buildInputs = [
    libevent
    libtool
    udev
    libusb1
    qrencode

    qtbase
    qtwebsockets
    qtmultimedia
  ];

  LUPDATE = "${qttools.dev}/bin/lupdate";
  LRELEASE = "${qttools.dev}/bin/lrelease";
  MOC = "${qtbase.dev}/bin/moc";
  QTDIR = qtbase.dev;
  RCC = "${qtbase.dev}/bin/rcc";
  UIC = "${qtbase.dev}/bin/uic";

  configureFlags = [
    "--enable-libusb"
  ];

  hardeningDisable = [
    "format"
  ];

  qtWrapperArgs = [ "--prefix LD_LIBRARY_PATH : $out/lib" ];

  postInstall = ''
    mkdir -p "$out/lib"
    cp src/libbtc/.libs/*.so* $out/lib
    cp src/libbtc/src/secp256k1/.libs/*.so* $out/lib
    cp src/hidapi/libusb/.libs/*.so* $out/lib
    cp src/univalue/.libs/*.so* $out/lib

    # Provide udev rules as documented in https://digitalbitbox.com/start_linux
    mkdir -p "$out/etc/udev/rules.d"
    ${copyUdevRuleToOutput "51-hid-digitalbox.rules" udevRule51}
    ${copyUdevRuleToOutput "52-hid-digitalbox.rules" udevRule52}
  '';

  # remove forbidden references to $TMPDIR
  preFixup = ''
    for f in "$out"/{bin,lib}/*; do
      if [ -f "$f" ] && isELF "$f"; then
        patchelf --shrink-rpath --allowed-rpath-prefixes "$NIX_STORE" "$f"
      fi
    done
  '';

  enableParallelBuilding = true;

  doInstallCheck = true;

  meta = with lib; {
    description = "QT based application for the Digital Bitbox hardware wallet";
    longDescription = ''
      Digital Bitbox provides dbb-app, a GUI tool, and dbb-cli, a CLI tool, to manage Digital Bitbox devices.

      This package will only install the dbb-app and dbb-cli, however; in order for these applications to identify and access Digital Bitbox devices, one may want to enable the digitalbitbox hardware module by adding

          hardware.digitalbitbox.enable = true;

      to the configuration which is equivalent to adding this package to the udev.packages list.


      The easiest way to use the digitalbitbox package in NixOS is by adding

          programs.digitalbitbox.enable = true;

      to the configuration which installs the package and enables the hardware module.
    '';
    homepage = "https://digitalbitbox.com/";
    license = licenses.mit;
    maintainers = with maintainers; [
      vidbina
    ];
    platforms = platforms.linux;
  };
}
