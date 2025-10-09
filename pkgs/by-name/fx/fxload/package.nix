{
  lib,
  stdenv,
  libusb1,
}:

stdenv.mkDerivation rec {
  pname = "fxload";
  version = libusb1.version;
  dontUnpack = true;
  dontBuild = true;
  dontConfigure = true;
  dontInstall = true;
  dontPatch = true;
  dontPatchELF = true;

  # fxload binary exist inside the `examples/bin` directory of `libusb1`
  postFixup = ''
    mkdir -p $out/bin
    ln -s ${passthru.libusb}/examples/bin/fxload $out/bin/fxload
  '';

  passthru.libusb = libusb1.override { withExamples = true; };

  meta = with lib; {
    homepage = "https://github.com/libusb/libusb";
    description = "Tool to upload firmware to into an21, fx, fx2, fx2lp and fx3 ez-usb devices";
    mainProgram = "fxload";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ logger ];
  };
}
