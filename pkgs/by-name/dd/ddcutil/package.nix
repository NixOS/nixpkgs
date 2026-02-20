{
  lib,
  stdenv,
  fetchFromGitHub,
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
  version = "2.2.5";

  src = fetchFromGitHub {
    owner = "rockowitz";
    repo = "ddcutil";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6Bf4I2bt7Ykn2P834tVIbTaY+7fae18zrs2I84Byv1Y=";
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
