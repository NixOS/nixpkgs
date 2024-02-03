{ mkDerivation, lib, fetchFromGitHub, fetchpatch
, cmake, extra-cmake-modules, pkg-config, qttools
, libxcb, libXau, pam, qtbase, qtdeclarative, qtquickcontrols2, systemd, xkeyboardconfig
}:
mkDerivation rec {
  pname = "sddm";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "sddm";
    repo = "sddm";
    rev = "v${version}";
    hash = "sha256-ctZln1yQov+p/outkQhcWZp46IKITC04e22RfePwEM4=";
  };

  patches = [
    ./sddm-ignore-config-mtime.patch
    ./sddm-default-session.patch

    # FIXME: all of the following are Wayland related backports, drop in next release
    # Don't use Qt virtual keyboard on Wayland
    (fetchpatch {
      url = "https://github.com/sddm/sddm/commit/07631f2ef00a52d883d0fd47ff7d1e1a6bc6358f.patch";
      hash = "sha256-HTSw3YeT4z9ldr4sLmsnrPQ+LA8/a6XxrF+KUFqXUlM=";
    })

    # Fix running sddm-greeter manually in Wayland sessions
    (fetchpatch {
      url = "https://github.com/sddm/sddm/commit/e27b70957505dc7b986ab2fa68219af546c63344.patch";
      hash = "sha256-6hzrFeS2epL9vzLOA29ZA/dD3Jd4rPMBHhNp+FBq1bA=";
    })

    # Prefer GreeterEnvironment over PAM environment
    (fetchpatch {
      url = "https://github.com/sddm/sddm/commit/9e7791d5fb375933d20f590daba9947195515b26.patch";
      hash = "sha256-JNsVTJNZV6T+SPqPkaFf3wg8NDqXGx8NZ4qQfZWOli4=";
    })
  ];

  postPatch = ''
    substituteInPlace src/greeter/waylandkeyboardbackend.cpp \
      --replace "/usr/share/X11/xkb/rules/evdev.xml" "${xkeyboardconfig}/share/X11/xkb/rules/evdev.xml"
  '';

  nativeBuildInputs = [ cmake extra-cmake-modules pkg-config qttools ];

  buildInputs = [
    libxcb
    libXau
    pam
    qtbase
    qtdeclarative
    qtquickcontrols2
    systemd
  ];

  cmakeFlags = [
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

  meta = with lib; {
    description = "QML based X11 display manager";
    homepage    = "https://github.com/sddm/sddm";
    maintainers = with maintainers; [ abbradar ttuegel ];
    platforms   = platforms.linux;
    license     = licenses.gpl2Plus;
  };
}
