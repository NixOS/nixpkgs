{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  glib,
  jansson,
  udev,
  libgudev,
  libusb1,
  libdrm,
  libxrandr,
  libxext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ddcutil";
  version = "2.2.6";

  src = fetchurl {
    url = "https://www.ddcutil.com/tarballs/ddcutil-${finalAttrs.version}.tar.gz";
    hash = "sha256-5LaRkcC0UK6iOjSlks88WPAn/hRiAgF5BwzJLV7K7Yg=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    glib
    jansson
    libdrm
    libgudev
    libusb1
    udev
    libxext
    libxrandr
  ];

  enableParallelBuilding = true;
  doInstallCheck = true;

  meta = {
    homepage = "http://www.ddcutil.com/";
    description = "Query and change Linux monitor settings using DDC/CI and USB";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ rnhmjoj ];
    changelog = "https://github.com/rockowitz/ddcutil/blob/v${finalAttrs.version}/CHANGELOG.md";
    mainProgram = "ddcutil";
  };
})
