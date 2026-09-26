{
  lib,
  stdenv,
  fetchzip,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hid-listen";
  version = "1.01";

  src = fetchzip {
    name = "hid_listen_${finalAttrs.version}";
    url = "https://www.pjrc.com/teensy/hid_listen_${finalAttrs.version}.zip";
    sha256 = "0sd4dvi39fl4vy880mg531ryks5zglfz5mdyyqr7x6qv056ffx9w";
  };

  installPhase = ''
    mkdir -p $out/bin
    mv ./hid_listen $out/bin/hid_listen
  '';

  meta = {
    description = "Tool thats prints debugging information from usb HID devices";
    homepage = "https://www.pjrc.com/teensy/hid_listen.html";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ tomsmeets ];
    platforms = lib.platforms.linux;
    mainProgram = "hid_listen";
  };
})
