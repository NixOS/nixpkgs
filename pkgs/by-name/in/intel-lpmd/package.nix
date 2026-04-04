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
  runCommand,
  configDirPrefix ? "/etc",
}:
let
  defaultConfigDir = "/share/intel-lpmd";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "intel-lpmd";
  version = "0.1.0-unstable-2026-06-09";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "intel-lpmd";
    rev = "40d18a6cc22c37addc3e636bc9c5cf1ab5d5fbda";
    hash = "sha256-gvPO7KqDVQDHC2DRDXJG52IYhHim8vex6Yrbsy3iLBI=";
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
    systemd
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

  passthru = {
    patchedConfigs =
      {
        PerformanceDef ? -1,
        BalancedDef ? -1,
        PowersaverDef ? -1,
      }@defs:
      lib.throwIf
        (
          !builtins.all (
            val:
            builtins.elem val [
              (-1)
              0
              1
            ]
          ) (builtins.attrValues defs)
        )
        "intel-lpmd.patchedConfigs expects PerformanceDef, BalancedDef, and PowersaverDef to be one of -1, 0, or 1"
        (
          runCommand "${finalAttrs.pname}-config-${finalAttrs.version}" { } ''
            mkdir -p "$out${defaultConfigDir}"
            cp -r ${finalAttrs.finalPackage}${defaultConfigDir}/. "$out${defaultConfigDir}/"

            for file in "$out${defaultConfigDir}"/*.xml; do
              substituteInPlace "$file" \
                --replace-fail "<PerformanceDef>-1</PerformanceDef>" "<PerformanceDef>${toString PerformanceDef}</PerformanceDef>" \
                --replace-fail "<BalancedDef>-1</BalancedDef>" "<BalancedDef>${toString BalancedDef}</BalancedDef>" \
                --replace-fail "<PowersaverDef>-1</PowersaverDef>" "<PowersaverDef>${toString PowersaverDef}</PowersaverDef>"
            done
          ''
        );
  };

  meta = with lib; {
    homepage = "https://github.com/intel/intel-lpmd";
    description = "Linux daemon used to optimize active idle power";
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
    maintainers = with maintainers; [ merrkry ];
    mainProgram = "intel_lpmd";
  };
})
