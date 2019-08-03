{ mkDerivation, lib, fetchFromGitHub
, cmake, extra-cmake-modules, pkgconfig, libxcb, libpthreadstubs
, libXdmcp, libXau, qtbase, qtdeclarative, qttools, pam, systemd
}:

let
  version = "0.18.1";

in mkDerivation rec {
  name = "sddm-${version}";

  src = fetchFromGitHub {
    owner = "sddm";
    repo = "sddm";
    rev = "v${version}";
    sha256 = "0an1zafz0yhxd9jgd3gzdwmaw5f9vs4c924q56lp2yxxddbmzjcq";
  };

  patches = [
    ./sddm-ignore-config-mtime.patch
  ];

  postPatch =
    # Fix missing include for gettimeofday()
    ''
      sed -e '1i#include <sys/time.h>' -i src/helper/HelperApp.cpp
    '';

  nativeBuildInputs = [ cmake extra-cmake-modules pkgconfig qttools ];

  buildInputs = [
    libxcb libpthreadstubs libXdmcp libXau pam qtbase qtdeclarative systemd
  ];

  cmakeFlags = [
    "-DCONFIG_FILE=/etc/sddm.conf"
    # Set UID_MIN and UID_MAX so that the build script won't try
    # to read them from /etc/login.defs (fails in chroot).
    # The values come from NixOS; they may not be appropriate
    # for running SDDM outside NixOS, but that configuration is
    # not supported anyway.
    "-DUID_MIN=1000"
    "-DUID_MAX=29999"

    "-DQT_IMPORTS_DIR=${placeholder "out"}/${qtbase.qtQmlPrefix}"
    "-DCMAKE_INSTALL_SYSCONFDIR=${placeholder "out"}/etc"
    "-DSYSTEMD_SYSTEM_UNIT_DIR=${placeholder "out"}/lib/systemd/system"
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
    homepage    = https://github.com/sddm/sddm;
    maintainers = with maintainers; [ abbradar ttuegel ];
    platforms   = platforms.linux;
    license     = licenses.gpl2Plus;
  };
}
