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
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "PixlOne";
    repo = "logiops";
    rev = "v${oldAttrs.version}";
    hash = "sha256-GAnlPqjIFGyOWwYFs7gth2m9ITc1jyiaW0sWwQ2zFOs=";
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
    mainProgram = "logid";
    homepage = "https://github.com/PixlOne/logiops";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = with platforms; linux;
  };
})
