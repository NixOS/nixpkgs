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
  acl,
  dbus,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ddcutil";
  version = "2.2.7";

  src = fetchurl {
    url = "https://www.ddcutil.com/tarballs/ddcutil-${finalAttrs.version}.tar.gz";
    hash = "sha256-GaxmBM8Rd7pWZm+KaCWB5x6Jc70Gx8jc8DNnTkqqpkg=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    acl
    dbus
    glib
    jansson
    libdrm
    libgudev
    libusb1
    libxext
    libxrandr
    udev
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
