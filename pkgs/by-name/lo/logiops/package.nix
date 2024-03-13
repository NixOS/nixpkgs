{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  glib,
  udev,
  libevdev,
  libconfig,
}:

stdenv.mkDerivation (oldAttrs: {
  pname = "logiops";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "PixlOne";
    repo = "logiops";
    rev = "v${oldAttrs.version}";
    sha256 = "sha256-9nFTud5szQN8jpG0e/Bkp+I9ELldfo66SdfVCUTuekg=";
    # In v0.3.0, the `ipcgull` submodule was added as a dependency
    # https://github.com/PixlOne/logiops/releases/tag/v0.3.0
    fetchSubmodules = true;
  };

  patches = [
    ./pkgs0001-Make-DBUS_SYSTEM_POLICY_INSTALL_DIR-externally-overr.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    udev
    libevdev
    libconfig
    glib
  ];

  cmakeFlags = [
    "-DLOGIOPS_VERSION=${oldAttrs.version}"
    "-DDBUS_SYSTEM_POLICY_INSTALL_DIR=${placeholder "out"}/share/dbus-1/system.d"
  ];

  PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "${placeholder "out"}/lib/systemd/system";

  meta = with lib; {
    description = "Unofficial userspace driver for HID++ Logitech devices";
    homepage = "https://github.com/PixlOne/logiops";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ckie ];
    platforms = with platforms; linux;
  };
})
