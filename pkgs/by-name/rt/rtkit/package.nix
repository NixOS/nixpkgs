{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  unixtools,
  dbus,
  libcap,
  polkit,
  systemd,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rtkit";
  version = "0.14";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "pipewire";
    repo = "rtkit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-y952SHbUWIjg1BKqenHABVWm0S5d/sBac1zRp9BpXB8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    unixtools.xxd
  ];

  buildInputs = [
    dbus
    libcap
    polkit
    systemd
  ];

  mesonFlags = [
    "-Dinstalled_tests=false"

    "-Ddbus_systemservicedir=${placeholder "out"}/share/dbus-1/system-services"
    "-Ddbus_interfacedir=${placeholder "out"}/share/dbus-1/interfaces"
    "-Ddbus_rulesdir=${placeholder "out"}/etc/dbus-1/system.d"
    "-Dpolkit_actiondir=${placeholder "out"}/share/polkit-1/actions"
    "-Dsystemd_systemunitdir=${placeholder "out"}/etc/systemd/system"
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "sysusersdir = '''" \
      "sysusersdir = '${placeholder "out"}/lib/sysusers.d'"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/pipewire/rtkit";
    description = "Daemon that hands out real-time priority to processes";
    mainProgram = "rtkitctl";
    license = with lib.licenses; [
      gpl3Plus
      mit
    ];
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.Gliczy ];
  };
})
