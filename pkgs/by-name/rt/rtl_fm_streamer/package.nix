{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libusb1,
  libev,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rtl_fm_streamer";
  version = "unstable-2021-06-08";

  src = fetchFromGitHub {
    owner = "AlbrechtL";
    repo = "rtl_fm_streamer";
    rev = "ceb2bf06883f986ed01aa57c84989ba35b6b9a27";
    hash = "sha256-9M7GS6AC7HEJge04vl7V6ZdtwWvbMu/Rhaf9fwQa9WA=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace '/etc/udev/rules.d' "$out/etc/udev/rules.d"

    substituteInPlace rtl-sdr.rules \
      --replace 'MODE:="0666"' 'ENV{ID_SOFTWARE_RADIO}="1", MODE="0660", GROUP="plugdev"'

    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.6)" "cmake_minimum_required(VERSION 3.10)"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libusb1
    libev
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
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64;
  };
})
