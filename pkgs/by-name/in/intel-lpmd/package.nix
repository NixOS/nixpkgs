{
  lib,
  stdenv,
  fetchFromGitHub,

  autoreconfHook,
  pkg-config,

  glib,
  gtk-doc,
  libnl,
  libxml2,
  systemd,
  upower,

  coreutils,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "intel-lpmd";
  version = "0.0.8";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "intel-lpmd";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-Af8H+hX9S7+AlFxFvClsRgEgt+bYqy9T+IWUkbUPVEw=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config

    glib
    gtk-doc
    libnl
    libxml2
    systemd
    upower
  ];

  postPatch = ''
    substituteInPlace "data/org.freedesktop.intel_lpmd.service.in" \
      --replace-fail "/bin/false" "${lib.getExe' coreutils "false"}"

    substituteInPlace "src/lpmd_dbus_server.c" \
      --replace-fail "src/intel_lpmd_dbus_interface.xml" "${placeholder "out"}/share/dbus-1/interfaces/org.freedesktop.intel_lpmd.xml"
  '';

  configureFlags = [
    ''--with-dbus-sys-dir="${placeholder "out"}/share/dbus-1/system.d"''
    ''--with-systemdsystemunitdir="${placeholder "out"}/lib/systemd/system"''
  ];

  postInstall = ''
    install -Dm644 src/intel_lpmd_dbus_interface.xml $out/share/dbus-1/interfaces/org.freedesktop.intel_lpmd.xml
  '';

  meta = with lib; {
    homepage = "https://github.com/intel/intel-lpmd";
    description = "Linux daemon used to optimize active idle power.";
    longDescription = ''
      Intel Low Power Model Daemon is a Linux daemon used to optimize active
      idle power. It selects a set of most power efficient CPUs based on
      configuration file or CPU topology. Based on system utilization and other
      hints, it puts the system into Low Power Mode by activate the power
      efficient CPUs and disable the rest, and restore the system from Low Power
      Mode by activating all CPUs.
    '';

    platforms = platforms.linux;
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ frontear ];

    mainProgram = "intel_lpmd";
  };
})
