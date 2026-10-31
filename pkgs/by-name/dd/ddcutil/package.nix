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
  version = "3.0.1";

  src = fetchurl {
    url = "https://www.ddcutil.com/tarballs/ddcutil-${finalAttrs.version}.tar.gz";
    hash = "sha256-HIYtwmOqKV8j2o2aZpNIfUzYyXqRveqkcRyrKKM83W4=";
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
