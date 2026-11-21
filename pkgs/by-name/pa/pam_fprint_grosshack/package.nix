{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  meson,
  ninja,
  glib,
  libfprint,
  polkit,
  systemd,
  pam,
  libpam-wrapper,
  dbus,
}:

stdenv.mkDerivation (finalAttrs: {

  pname = "pam_fprint_grosshack";
  version = "0.3.0";

  src = fetchFromGitLab {
    owner = "mishakmak";
    repo = "pam-fprint-grosshack";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-obczZbf/oH4xGaVvp3y3ZyDdYhZnxlCWvL0irgEYIi0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [
    glib
    dbus
    libfprint
    polkit
    systemd
    pam
    libpam-wrapper
  ];

  mesonFlags = [
    "-Dpam_modules_dir=${placeholder "out"}/lib/security"
    "-Dsysconfdir=${placeholder "out"}/etc"
    "-Ddbus_service_dir=${placeholder "out"}/share/dbus-1/system-services"
    "-Dsystemd_system_unit_dir=${placeholder "out"}/lib/systemd/system"
  ];

  env = {
    PKG_CONFIG_DBUS_1_INTERFACES_DIR = "${placeholder "out"}/share/dbus-1/interfaces";
    PKG_CONFIG_POLKIT_GOBJECT_1_POLICYDIR = "${placeholder "out"}/share/polkit-1/actions";
    PKG_CONFIG_DBUS_1_DATADIR = "${placeholder "out"}/share";
  };

  meta = {
    description = "PAM Fprint module which implements the simultaneous password and fingerprint behaviour";
    homepage = "https://gitlab.com/mishakmak/pam-fprint-grosshack";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ agvantibo ];
  };
})
