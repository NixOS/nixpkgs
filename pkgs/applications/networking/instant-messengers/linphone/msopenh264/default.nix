{
  mediastreamer2,
  openh264,
  lib,
  mkLinphoneDerivation,
}:
mkLinphoneDerivation {
  pname = "msopenh264";

  buildInputs = [
    mediastreamer2
    openh264
  ];

  # CMAKE_INSTALL_PREFIX has no effect so let's install manually. See:
  # https://gitlab.linphone.org/BC/public/msopenh264/issues/1
  installPhase = ''
    mkdir -p $out/lib/mediastreamer/plugins
    cp lib/mediastreamer2/plugins/libmsopenh264.so $out/lib/mediastreamer/plugins/
  '';

  meta = {
    description = "H.264 encoder/decoder plugin for mediastreamer2. Part of the Linphone project";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
