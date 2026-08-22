{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  libusb1,
  pcsclite,
  writeText,
}:

let
  version = "3.99.5";
  suffix = "SP15";
  tarBall = "${version}final.${suffix}";
  # source: https://salsa.debian.org/debian/pcsc-cyberjack/-/blob/master/debian/libifd-cyberjack6.udev?ref_type=heads
  udevRules = writeText "pcsc-cyberjack.rules" ''
    # If not adding the device, go away
    ACTION!="add", GOTO="cyberjack_rules_end"
    SUBSYSTEM!="usb", GOTO="cyberjack_rules_end"
    ENV{DEVTYPE}!="usb_device", GOTO="cyberjack_rules_end"

    ATTR{idVendor}=="0c4b", ATTR{idProduct}=="0100", MODE="660", GROUP="pcscd"
    ATTR{idVendor}=="0c4b", ATTR{idProduct}=="0300", MODE="660", GROUP="pcscd"
    ATTR{idVendor}=="0c4b", ATTR{idProduct}=="0400", MODE="660", GROUP="pcscd"
    ATTR{idVendor}=="0c4b", ATTR{idProduct}=="0401", MODE="660", GROUP="pcscd"
    ATTR{idVendor}=="0c4b", ATTR{idProduct}=="0412", MODE="660", GROUP="pcscd"
    ATTR{idVendor}=="0c4b", ATTR{idProduct}=="0485", MODE="660", GROUP="pcscd"
    ATTR{idVendor}=="0c4b", ATTR{idProduct}=="0500", MODE="660", GROUP="pcscd"
    ATTR{idVendor}=="0c4b", ATTR{idProduct}=="0501", MODE="660", GROUP="pcscd"
    ATTR{idVendor}=="0c4b", ATTR{idProduct}=="0502", MODE="660", GROUP="pcscd"
    ATTR{idVendor}=="0c4b", ATTR{idProduct}=="0503", MODE="660", GROUP="pcscd"
    ATTR{idVendor}=="0c4b", ATTR{idProduct}=="0504", MODE="660", GROUP="pcscd"
    ATTR{idVendor}=="0c4b", ATTR{idProduct}=="0505", MODE="660", GROUP="pcscd"
    ATTR{idVendor}=="0c4b", ATTR{idProduct}=="0506", MODE="660", GROUP="pcscd"
    ATTR{idVendor}=="0c4b", ATTR{idProduct}=="0507", MODE="660", GROUP="pcscd"
    ATTR{idVendor}=="0c4b", ATTR{idProduct}=="0525", MODE="660", GROUP="pcscd"
    ATTR{idVendor}=="0c4b", ATTR{idProduct}=="0580", MODE="660", GROUP="pcscd"
    ATTR{idVendor}=="0c4b", ATTR{idProduct}=="2000", MODE="660", GROUP="pcscd"
    ATTR{idVendor}=="0c4b", ATTR{idProduct}=="0551", MODE="660", GROUP="pcscd"
    ATTR{idVendor}=="0c4b", ATTR{idProduct}=="2002", MODE="660", GROUP="pcscd"

    # All done
    LABEL="cyberjack_rules_end"
  '';

in
stdenv.mkDerivation rec {
  pname = "pcsc-cyberjack";
  inherit version;

  src = fetchurl {
    url = "https://support.reiner-sct.de/downloads/LINUX/V${version}_${suffix}/pcsc-cyberjack_${tarBall}.tar.bz2";
    sha256 = "sha256-rLfCgyRQcYdWcTdnxLPvUAgy1lLtUbNRELkQsR69Rno=";
  };

  outputs = [
    "out"
    "tools"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libusb1
    pcsclite
  ];

  enableParallelBuilding = true;

  env.NIX_CFLAGS_COMPILE = "-Wno-error=narrowing";

  configureFlags = [
    "--with-usbdropdir=${placeholder "out"}/pcsc/drivers"
    "--bindir=${placeholder "tools"}/bin"
  ];

  postInstall = ''
    make -C tools/cjflash install

    mkdir -p $out/lib/udev/rules.d
    ln -s "${udevRules}" $out/lib/udev/rules.d/90-pcsc-cyberjack.rules
  '';

  meta = {
    description = "REINER SCT cyberJack USB chipcard reader user space driver";
    mainProgram = "cjflash";
    homepage = "https://www.reiner-sct.com/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      aszlig
      flokli
    ];
    platforms = lib.platforms.linux;
  };
}
