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
  systemdLibs,
  upower,
  coreutils,
  configDirPrefix ? "/etc",
}:
let
  defaultConfigDir = "/share/intel-lpmd";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "intel-lpmd";
  version = "0.1.0-unstable-2026-09-23";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "intel-lpmd";
    rev = "9bf8b8de3ed11c301817814fef79b3161e6294b6";
    hash = "sha256-mCR7ZGk79Hnl2zp8ywHSbi5Fk1ofNfsDt2joF61aHko=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    glib
    autoreconfHook
    pkg-config
    gtk-doc
  ];

  buildInputs = [
    glib
    libnl
    libxml2
    systemdLibs
    upower
  ];

  postPatch = ''
    substituteInPlace "data/Makefile.am" \
      --replace-fail 'lpmd_configdir = $(lpmd_confdir)' 'lpmd_configdir = ${placeholder "out"}${defaultConfigDir}'

    substituteInPlace "data/org.freedesktop.intel_lpmd.service.in" \
      --replace-fail "/bin/false" "${lib.getExe' coreutils "false"}"
  '';

  configureFlags = [
    "--sysconfdir=${configDirPrefix}"
    "--localstatedir=/var"
    "--with-dbus-sys-dir=${placeholder "out"}/share/dbus-1/system.d"
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
  ];

  meta = {
    homepage = "https://github.com/intel/intel-lpmd";
    description = "Daemon that optimizes active idle power on Intel CPUs";
    longDescription = ''
      Intel Low Power Mode Daemon selects the most power-efficient CPUs based
      on a configuration file or CPU topology. Depending on system utilization
      and other hints, it puts the system into Low Power Mode by activating the
      power-efficient CPUs and disabling the rest, and restores the system from
      Low Power Mode by activating all CPUs.
    '';
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.merrkry ];
    mainProgram = "intel_lpmd";
  };
})
