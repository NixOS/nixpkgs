{
  lib,
  python3Packages,
  fetchPypi,
  avrdude,
  bootloadhid,
  dfu-programmer,
  dfu-util,
  wb32-dfu-updater,
  gnumake,
  teensy-loader-cli,
  binutils,
  gcc,
  libc,
}:
let
  runtimeBuildTools = [
    avrdude
    bootloadhid
    dfu-programmer
    dfu-util
    wb32-dfu-updater
    teensy-loader-cli
    gnumake
    binutils
    binutils.bintools
    gcc
    libc
  ];
in
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "qmk";
  version = "1.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-FkvRbExAGyt2XuTwF7z6gUGULd82KWHEy6GXXYyyikg=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    dotty-dict
    hid
    hjson
    jsonschema
    milc
    pygments
    pyserial
    pyusb
    pillow
  ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    "${lib.makeBinPath runtimeBuildTools}"
  ];

  # no tests implemented
  doCheck = false;

  # Passthru helper for getting the AVR-targetting QMK
  passthru.avr = pkgsCross.buildPackages.qmk;

  meta = {
    homepage = "https://github.com/qmk/qmk_cli";
    description = "Program to help users work with QMK Firmware";
    longDescription = ''
      qmk_cli is a companion tool to QMK firmware. With it, you can:

      - Interact with your qmk_firmware tree from any location
      - Use qmk clone to pull down anyone's qmk_firmware fork
      - Setup and work with your build environment:
        - qmk setup
        - qmk doctor
        - qmk compile
        - qmk console
        - qmk flash
        - qmk lint
      - ... and many more!
    '';
    license = lib.licenses.PLUS lib.licenses.gpl2;
    maintainers = [ lib.maintainers.RossSmyth ];
    mainProgram = "qmk";
  };
})
