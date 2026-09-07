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

stdenv.mkDerivation (finalAttrs: {
  pname = "logiops";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "PixlOne";
    repo = "logiops";
    tag = "v${finalAttrs.version}";
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
    "-DLOGIOPS_VERSION=${finalAttrs.version}"
    "-DDBUS_SYSTEM_POLICY_INSTALL_DIR=${placeholder "out"}/share/dbus-1/system.d"
  ];

  env.PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "${placeholder "out"}/lib/systemd/system";

  meta = {
    description = "Unofficial userspace driver for HID++ Logitech devices";
    mainProgram = "logid";
    homepage = "https://github.com/PixlOne/logiops";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = with lib.platforms; linux;
  };
})
