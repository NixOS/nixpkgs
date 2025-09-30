{
  lib,
  stdenv,
  fetchFromGitHub,
  flex,
  libusb1,
  meson,
  ninja,
  nix-update-script,
  pcsclite,
  perl,
  pkg-config,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "ccid";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "LudovicRousseau";
    repo = "CCID";
    tag = version;
    hash = "sha256-n7rOjnLZH4RLmddtBycr3FK2Bi/OLR+9IjWBRbWjnUw=";
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

  doInstallCheck = true;

  postInstall = ''
    install -Dm 0444 -t $out/lib/udev/rules.d ../src/92_pcscd_ccid.rules
    substituteInPlace $out/lib/udev/rules.d/92_pcscd_ccid.rules \
      --replace-fail "/usr/sbin/pcscd" "${pcsclite}/bin/pcscd"
  '';

  # The resulting shared object ends up outside of the default paths which are
  # usually getting stripped.
  stripDebugList = [ "pcsc" ];

  passthru.updateScript = nix-update-script { };

  installCheckPhase =
    let
      platform = if stdenv.hostPlatform.isLinux then "Linux" else "MacOS";
    in
    lib.optionalString (stdenv.hostPlatform.isLinux || stdenv.hostPlatform.isDarwin) ''
      runHook preInstallCheck

      [ -f $out/etc/reader.conf.d/libccidtwin ]
      [ -f $out/lib/udev/rules.d/92_pcscd_ccid.rules ]
      [ -f $out/pcsc/drivers/ifd-ccid.bundle/Contents/Info.plist ]
      [ -f $out/pcsc/drivers/ifd-ccid.bundle/Contents/${platform}/libccid${stdenv.hostPlatform.extensions.sharedLibrary} ]
      [ -f $out/pcsc/drivers/serial/libccidtwin${stdenv.hostPlatform.extensions.sharedLibrary} ]

      runHook postInstallCheck
    '';

  meta = with lib; {
    description = "PC/SC driver for USB CCID smart card readers";
    homepage = "https://ccid.apdu.fr/";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.anthonyroussel ];
    platforms = platforms.unix;
  };
}
