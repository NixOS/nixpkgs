{
  lib,
  buildPythonPackage,
  fetchFromCodeberg,
  sdcc,
  libusb1,
  setuptools-scm,
  crcmod,
}:

buildPythonPackage (finalAttrs: {
  pname = "fx2";
  version = "0.16";
  format = "setuptools";

  src = fetchFromCodeberg {
    owner = "GlasgowEmbedded";
    repo = "libfx2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0AHFjb3dhkr3VVFHFNB/gpQKcqh0oGST1NoeZhdtT6o=";
  };

  nativeBuildInputs = [
    setuptools-scm
    sdcc
  ];

  propagatedBuildInputs = [
    libusb1
    crcmod
  ];

  preBuild = ''
    make -C firmware
    cd software
  '';

  preInstall = ''
    mkdir -p $out/share/libfx2
    cp -R ../firmware/library/{.stamp,lib,include,fx2{rules,conf}.mk} \
      $out/share/libfx2
  '';

  # installCheckPhase tries to run build_ext again and there are no tests
  doCheck = false;

  meta = {
    description = "Chip support package for Cypress EZ-USB FX2 series microcontrollers";
    mainProgram = "fx2tool";
    homepage = "https://codeberg.org/GlasgowEmbedded/libfx2";
    license = lib.licenses.bsd0;
    maintainers = [ ];
  };
})
