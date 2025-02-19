{
  lib,
  stdenv,
  fetchurl,
  flex,
  gitUpdater,
  libusb1,
  meson,
  ninja,
  pcsclite,
  perl,
  pkg-config,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "ccid";
  version = "1.6.1";

  src = fetchurl {
    url = "https://ccid.apdu.fr/files/${pname}-${version}.tar.xz";
    hash = "sha256-LsqPsH6P58DTna6sp7l81zxA7Ztyc4okrT3L38kY4eo=";
  };

  postPatch = ''
    patchShebangs .
    substituteInPlace meson.build --replace-fail \
      "pcsc_dep.get_variable('usbdropdir')" \
      "'$out/pcsc/drivers'"
  '';

  mesonFlags = [
    (lib.mesonBool "serial" true)
  ];

  # error: call to undeclared function 'InterruptRead';
  # ISO C99 and later do not support implicit function declarations
  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";
  };

  nativeBuildInputs = [
    flex
    perl
    pkg-config
    meson
    ninja
  ];

  buildInputs = [
    libusb1
    pcsclite
    zlib
  ];

  postInstall = ''
    install -Dm 0444 -t $out/lib/udev/rules.d ../src/92_pcscd_ccid.rules
    substituteInPlace $out/lib/udev/rules.d/92_pcscd_ccid.rules \
      --replace-fail "/usr/sbin/pcscd" "${pcsclite}/bin/pcscd"
  '';

  # The resulting shared object ends up outside of the default paths which are
  # usually getting stripped.
  stripDebugList = [ "pcsc" ];

  passthru.updateScript = gitUpdater {
    url = "https://salsa.debian.org/rousseau/CCID.git";
  };

  installCheckPhase = ''
    [ -f $out/etc/reader.conf.d/libccidtwin ]
    [ -f $out/lib/udev/rules.d/92_pcscd_ccid.rules ]
    [ -f $out/pcsc/drivers/ifd-ccid.bundle/Contents/Info.plist ]
    [ -f $out/pcsc/drivers/ifd-ccid.bundle/Contents/Linux/libccid.so ]
    [ -f $out/pcsc/drivers/serial/libccidtwin.so ]
  '';

  meta = with lib; {
    description = "PC/SC driver for USB CCID smart card readers";
    homepage = "https://ccid.apdu.fr/";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.anthonyroussel ];
    platforms = platforms.unix;
  };
}
