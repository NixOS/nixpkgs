{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dvd-vr";
  version = "0.9.7";
  src = fetchurl {
    url = "https://www.pixelbeat.org/programs/dvd-vr/dvd-vr-${finalAttrs.version}.tar.gz";
    sha256 = "13wkdia3c0ryda40b2nzpb9vddimasgc4w95hvl0k555k9k8bl0r";
  };

  makeFlags = [
    "PREFIX=$(out)"
    # Fix build with GCC 14
    "CFLAGS=-Wno-error=incompatible-pointer-types"
  ];

  meta = with lib; {
    homepage = "https://www.pixelbeat.org/programs/dvd-vr/";
    downloadPage = "https://www.pixelbeat.org/programs/dvd-vr/";
    description = "Utility to identify and optionally copy recordings from a DVD-VR format disc";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fgaz ];
    mainProgram = "dvd-vr";
  };
})
