<<<<<<< HEAD
{ mkDerivation, lib, fetchFromGitHub
, cmake, extra-cmake-modules, pkg-config, qttools
, libxcb, libXau, pam, qtbase, qtdeclarative, qtquickcontrols2, systemd, xkeyboardconfig
}:
mkDerivation rec {
  pname = "sddm";
  version = "0.20.0";
=======
{ mkDerivation, lib, fetchFromGitHub, fetchpatch
, cmake, extra-cmake-modules, pkg-config, libxcb, libpthreadstubs
, libXdmcp, libXau, qtbase, qtdeclarative, qtquickcontrols2, qttools, pam, systemd
}:

let
  version = "0.19.0";

in mkDerivation {
  pname = "sddm";
  inherit version;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "sddm";
    repo = "sddm";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-ctZln1yQov+p/outkQhcWZp46IKITC04e22RfePwEM4=";
=======
    sha256 = "1s6icb5r1n6grfs137gdzfrcvwsb3hvlhib2zh6931x8pkl1qvxa";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    ./sddm-ignore-config-mtime.patch
    ./sddm-default-session.patch
<<<<<<< HEAD
  ];

  postPatch = ''
    substituteInPlace src/greeter/waylandkeyboardbackend.cpp \
      --replace "/usr/share/X11/xkb/rules/evdev.xml" "${xkeyboardconfig}/share/X11/xkb/rules/evdev.xml"
  '';
=======
    # Load `/etc/profile` for `environment.variables` with zsh default shell.
    # See: https://github.com/sddm/sddm/pull/1382
    (fetchpatch {
      url = "https://github.com/sddm/sddm/commit/e1dedeeab6de565e043f26ac16033e613c222ef9.patch";
      sha256 = "sha256-OPyrUI3bbH+PGDBfoL4Ohb4wIvmy9TeYZhE0JxR/D58=";
    })
    # Fix build with Qt 5.15.3
    # See: https://github.com/sddm/sddm/pull/1325
    (fetchpatch {
      url = "https://github.com/sddm/sddm/commit/e93bf95c54ad8c2a1604f8d7be05339164b19308.patch";
      sha256 = "sha256:1rh6sdvzivjcl5b05fczarvxhgpjhi7019hvf2gadnwgwdg104r4";
    })
    # Fix fails to start while starting X server
    # See: https://github.com/sddm/sddm/pull/1324
    (fetchpatch {
      url = "https://github.com/sddm/sddm/commit/adfaa222fdfa6115ea2b320b0bbc2126db9270a5.patch";
      sha256 = "sha256-q/YLlAjxluzHMKUUQglLo3RyyhERQGPHXGr56+4R9VU=";
    })
  ];

  postPatch =
    # Fix missing include for gettimeofday()
    ''
      sed -e '1i#include <sys/time.h>' -i src/helper/HelperApp.cpp
    '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ cmake extra-cmake-modules pkg-config qttools ];

  buildInputs = [
<<<<<<< HEAD
    libxcb
    libXau
    pam
    qtbase
    qtdeclarative
    qtquickcontrols2
    systemd
=======
    libxcb libpthreadstubs libXdmcp libXau pam qtbase qtdeclarative qtquickcontrols2 systemd
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  cmakeFlags = [
    "-DCONFIG_FILE=/etc/sddm.conf"
<<<<<<< HEAD
    "-DCONFIG_DIR=/etc/sddm.conf.d"

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    # Set UID_MIN and UID_MAX so that the build script won't try
    # to read them from /etc/login.defs (fails in chroot).
    # The values come from NixOS; they may not be appropriate
    # for running SDDM outside NixOS, but that configuration is
    # not supported anyway.
    "-DUID_MIN=1000"
    "-DUID_MAX=29999"

<<<<<<< HEAD
    # we still want to run the DM on VT 7 for the time being, as 1-6 are
    # occupied by getties by default
    "-DSDDM_INITIAL_VT=7"

    "-DQT_IMPORTS_DIR=${placeholder "out"}/${qtbase.qtQmlPrefix}"
    "-DCMAKE_INSTALL_SYSCONFDIR=${placeholder "out"}/etc"
    "-DSYSTEMD_SYSTEM_UNIT_DIR=${placeholder "out"}/lib/systemd/system"
    "-DSYSTEMD_SYSUSERS_DIR=${placeholder "out"}/lib/sysusers.d"
    "-DSYSTEMD_TMPFILES_DIR=${placeholder "out"}/lib/tmpfiles.d"
=======
    "-DQT_IMPORTS_DIR=${placeholder "out"}/${qtbase.qtQmlPrefix}"
    "-DCMAKE_INSTALL_SYSCONFDIR=${placeholder "out"}/etc"
    "-DSYSTEMD_SYSTEM_UNIT_DIR=${placeholder "out"}/lib/systemd/system"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
