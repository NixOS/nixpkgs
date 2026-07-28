{
  lib,
  stdenv,
  fetchurl,
  patchelf,
  libusb-compat-0_1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "scmccid";
  version = "5.0.35";

  src =
    if stdenv.hostPlatform.system == "i686-linux" then
      (fetchurl {
        url = "https://scm-pc-card.de/file/driver/Readers_Writers/scmccid_${finalAttrs.version}_linux_rel.tar.gz";
        hash = "sha256-eRqAoe7uZUTTLh3K3bc4PmVmqJtvSpfOBWXdjydN72U=";
      })
    else if stdenv.hostPlatform.system == "x86_64-linux" then
      (fetchurl {
        url = "https://scm-pc-card.de/file/driver/Readers_Writers/scmccid_${finalAttrs.version}_linux_rel_64.tar.gz";
        hash = "sha256-SFf3QC+1hZCWIgIOEAfIHR68PHFXTW8amT4D5UMTMeQ=";
      })
    else
      throw "Architecture not supported";

  nativeBuildInputs = [ patchelf ];

  installPhase = ''
    runHook preInstall

    for a in proprietary/*/Contents/Linux/*.so*; do
        if ! test -L $a; then
            patchelf --set-rpath ${
              lib.makeLibraryPath [
                libusb-compat-0_1
                stdenv.cc.libc
              ]
            } $a
        fi
    done

    mkdir -p $out/pcsc/drivers
    cp -R proprietary/* $out/pcsc/drivers

     runHook postInstall
  '';

  meta = {
    homepage = "http://support.identiv.com/products";
    description = "PCSC drivers for linux, for the SCM SCR3310 v2.0 card and others";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
