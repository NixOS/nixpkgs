{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  libusb1,
  pcsclite,
}:

let
  version = "3.99.5";
  suffix = "SP17";
  tarBall = "${version}final.${suffix}";

  # upstream doesn't ship this udev file, but it's necessary for pcscd to be able to open the device,
  # as we don't run pcscd as root anymore.
  udevFile = fetchurl {
    url = "https://src.fedoraproject.org/rpms/pcsc-cyberjack/raw/a32e58b6e3d124a1fc28648b01a0d62013d96aa1/f/libifd-cyberjack6.udev";
    hash = "sha256-JnPc8xqCcbbriEeCjFCL/nQsXLg47NIuniba7vVtj2Y=";
  };

in
stdenv.mkDerivation rec {
  pname = "pcsc-cyberjack";
  inherit version;

  src = fetchurl {
    url = "https://support.reiner-sct.de/downloads/LINUX/V${version}_${suffix}/pcsc-cyberjack-${tarBall}.tar.bz2";
    sha256 = "sha256-8ajhXbOkJosNecMqdhlbNNeVGLuJFoVEPiUzEfnp0wo=";
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
    install -Dm644 ${udevFile} $out/lib/udev/rules.d/93-cyberjack.rules
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
