{
  stdenv,
  fetchFromGitLab,
  meson,
  pkg-config,
  docutils,
  ninja,
  glib,
  libvirt,
  libvirt-glib,
  systemd,
  gitUpdater,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libvirt-dbus";
  version = "1.4.1";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitLab {
    owner = "libvirt";
    repo = "libvirt-dbus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-S4QktQmcnTte4XsIcgc5dkA8LjMJaOD2lljS01WT0dk=";
  };

  postPatch = ''
    substituteInPlace "data/system/meson.build" \
      --replace-fail ": systemd_system_unit_dir" ": '$out/lib/systemd/system'"

    substituteInPlace "data/session/meson.build" \
      --replace-fail ": systemd_user_unit_dir" ": '$out/lib/systemd/user'"
  '';

  nativeBuildInputs = [
    meson
    pkg-config
    docutils
    ninja
  ];

  buildInputs = [
    glib
    libvirt
    libvirt-glib
    systemd
  ];

  mesonFlags = [
    (lib.mesonOption "init_script" "systemd")
    (lib.mesonOption "unix_socket_group" "qemu-libvirtd")
    # TODO: uncomment below on next release
    # (lib.mesonOption "sysusersdir" "${placeholder "out"}/lib/sysusers.d")
  ];

  doCheck = false; # needs running D-Bus and libvirt

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = {
    description = "libvirt D-Bus API binding";
    homepage = "https://libvirt.org/dbus.html";
    changelog = "https://gitlab.com/libvirt/libvirt-dbus/-/blob/v${finalAttrs.version}/NEWS.rst";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ andre4ik3 ];
  };
})
