{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libusb1,
  libev,
  rtl-sdr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rtl_fm_streamer";
  version = "0-unstable-2026-05-23";

  src = fetchFromGitHub {
    owner = "AlbrechtL";
    repo = "rtl_fm_streamer";
    rev = "7d98bcee154be86b772ab9440bc65361ac2cad67";
    hash = "sha256-IlZcxu9JMaiqY+Vu6Bv14JxpQeJqytugW4mAvS0qIKY=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libusb1
    libev
    rtl-sdr
  ];

  cmakeFlags = [
    (lib.cmakeBool "INSTALL_UDEV_RULES" stdenv.hostPlatform.isLinux)
  ];

  doInstallCheck = true;

  meta = {
    description = "Turns your Realtek RTL2832 based DVB dongle into a FM radio stereo receiver";
    homepage = "https://github.com/AlbrechtL/rtl_fm_streamer";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})
