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
  version = "0.1.0-unstable-2026-09-16";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "intel-lpmd";
    rev = "aa230ffb3c1085a77cb7ab84fba654c3e72e43c0";
    hash = "sha256-yHyS8jvxPmezDlEERPIS9eK8hIYSIcKXxX0hYny82AY=";
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
              2
            ]
          ) (builtins.attrValues defs)
        )
        "intel-lpmd.patchedConfigs expects PerformanceDef, BalancedDef, and PowersaverDef to be one of -1, 0, 1, or 2"
        (
          runCommand "${finalAttrs.pname}-config-${finalAttrs.version}" { } ''
            mkdir -p "$out${defaultConfigDir}"
            cp -r ${finalAttrs.finalPackage}${defaultConfigDir}/. "$out${defaultConfigDir}/"

            # Profile defaults differ between platforms; process rules have no profile defaults.
            for file in "$out${defaultConfigDir}"/intel_lpmd_config*.xml; do
              substituteInPlace "$file" \
                --replace-fail "$(grep -o '<PerformanceDef>[^<]*</PerformanceDef>' "$file")" "<PerformanceDef>${toString PerformanceDef}</PerformanceDef>" \
                --replace-fail "$(grep -o '<BalancedDef>[^<]*</BalancedDef>' "$file")" "<BalancedDef>${toString BalancedDef}</BalancedDef>" \
                --replace-fail "$(grep -o '<PowersaverDef>[^<]*</PowersaverDef>' "$file")" "<PowersaverDef>${toString PowersaverDef}</PowersaverDef>"
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
