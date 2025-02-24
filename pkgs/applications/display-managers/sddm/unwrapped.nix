{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qttools,
  libxcb,
  libXau,
  pam,
  qtbase,
  qtdeclarative,
  qtquickcontrols2 ? null,
  systemd,
  xkeyboardconfig,
  nixosTests,
}:
let
  isQt6 = lib.versions.major qtbase.version == "6";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "sddm-unwrapped";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "sddm";
    repo = "sddm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-r5mnEWham2WnoEqRh5tBj/6rn5mN62ENOCmsLv2Ht+w=";
  };

  patches = [
    ./greeter-path.patch
    ./sddm-ignore-config-mtime.patch
    ./sddm-default-session.patch
  ];

  postPatch = ''
    substituteInPlace src/greeter/waylandkeyboardbackend.cpp \
      --replace "/usr/share/X11/xkb/rules/evdev.xml" "${xkeyboardconfig}/share/X11/xkb/rules/evdev.xml"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
  ];

  buildInputs = [
    libxcb
    libXau
    pam
    qtbase
    qtdeclarative
    qtquickcontrols2
    systemd
  ];

  # We will wrap manually later
  dontWrapQtApps = true;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_WITH_QT6" isQt6)
    "-DCONFIG_FILE=/etc/sddm.conf"
    "-DCONFIG_DIR=/etc/sddm.conf.d"

    # Set UID_MIN and UID_MAX so that the build script won't try
    # to read them from /etc/login.defs (fails in chroot).
    # The values come from NixOS; they may not be appropriate
    # for running SDDM outside NixOS, but that configuration is
    # not supported anyway.
    "-DUID_MIN=1000"
    "-DUID_MAX=29999"

    # we still want to run the DM on VT 7 for the time being, as 1-6 are
    # occupied by getties by default
    "-DSDDM_INITIAL_VT=7"

    "-DQT_IMPORTS_DIR=${placeholder "out"}/${qtbase.qtQmlPrefix}"
    "-DCMAKE_INSTALL_SYSCONFDIR=${placeholder "out"}/etc"
    "-DSYSTEMD_SYSTEM_UNIT_DIR=${placeholder "out"}/lib/systemd/system"
    "-DSYSTEMD_SYSUSERS_DIR=${placeholder "out"}/lib/sysusers.d"
    "-DSYSTEMD_TMPFILES_DIR=${placeholder "out"}/lib/tmpfiles.d"
    "-DDBUS_CONFIG_DIR=${placeholder "out"}/share/dbus-1/system.d"
  ];

  postInstall = ''
    # remove empty scripts
    rm "$out/share/sddm/scripts/Xsetup" "$out/share/sddm/scripts/Xstop"
    for f in $out/share/sddm/themes/**/theme.conf ; do
      substituteInPlace $f \
        --replace 'background=' "background=$(dirname $f)/"
    done
  '';

  passthru.tests = { inherit (nixosTests) sddm; };

  meta = with lib; {
    description = "QML based X11 display manager";
    homepage = "https://github.com/sddm/sddm";
    maintainers = with maintainers; [
      abbradar
      ttuegel
      k900
    ];
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
})
