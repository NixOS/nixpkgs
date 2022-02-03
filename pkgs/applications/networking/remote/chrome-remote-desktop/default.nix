{ enableNewSession ? false, stdenv, pkgs, lib, config, fetchurl, fetchgit, dpkg, python3, glibc, glib, pam, nss
, nspr, expat, gtk3, dconf, xorg, fontconfig, dbus, alsaLib, shadow, mesa, libdrm, libxkbcommon, wayland }:
stdenv.mkDerivation rec {
  pname = "chrome-remote-desktop";
  version = "unstable-2022-02-03";

  src = fetchurl {
    sha256 = "sha256-CNE3kvAj7Jp4cB5x2D/YUA1H9Ri397C6rxQBRmstz1c=";
    url = "https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb";
  };

  buildInputs = [ pkgs.makeWrapper ];

  dontBuild = true;
  dontConfigure = true;

  unpackPhase = ''
    ${dpkg}/bin/dpkg -x $src $out
  '';

  installPhase = ''
    mkdir $out/bin
    makeWrapper $out/opt/google/chrome-remote-desktop/chrome-remote-desktop $out/bin/chrome-remote-desktop
  '';

  replacePrefix = "/opt/google/chrome-remote-desktop";
  replaceTarget = "/run/current-system/sw/bin/./././";

  patchPhase =
  ''
    sed \
    -e '/^.*sudo_command =/ s/"gksudo .*"/"pkexec"/' \
    -e '/^.*command =/ s/s -- sh -c/s sh -c/' \
    -i $out/opt/google/chrome-remote-desktop/chrome-remote-desktop
    substituteInPlace $out/etc/opt/chrome/native-messaging-hosts/com.google.chrome.remote_desktop.json --replace $replacePrefix/native-messaging-host $out/$replacePrefix/native-messaging-host
    substituteInPlace $out/etc/opt/chrome/native-messaging-hosts/com.google.chrome.remote_assistance.json --replace $replacePrefix/remote-assistance-host $out/$replacePrefix/remote-assistance-host

    substituteInPlace $out/$replacePrefix/chrome-remote-desktop --replace "USER_SESSION_PATH = " "USER_SESSION_PATH = \"/run/wrappers/bin/crd-user-session\" #"
    substituteInPlace $out/$replacePrefix/chrome-remote-desktop --replace /usr/bin/python3 ${python3.withPackages (ps: with ps; [ psutil ])}/bin/python3
    substituteInPlace $out/$replacePrefix/chrome-remote-desktop --replace '"Xvfb"' '"${xorg.xorgserver}/bin/Xvfb"'
    substituteInPlace $out/$replacePrefix/chrome-remote-desktop --replace '"Xorg"' '"${xorg.xorgserver}/bin/Xorg"'
    substituteInPlace $out/$replacePrefix/chrome-remote-desktop --replace '"xrandr"' '"${xorg.xrandr}/bin/xrandr"'
    substituteInPlace $out/$replacePrefix/chrome-remote-desktop --replace /usr/lib/xorg/modules ${xorg.xorgserver}/lib/xorg/modules
    substituteInPlace $out/$replacePrefix/chrome-remote-desktop --replace xdpyinfo ${xorg.xdpyinfo}/bin/xdpyinfo
    substituteInPlace $out/$replacePrefix/chrome-remote-desktop --replace /usr/bin/sudo /run/wrappers/bin/sudo
    substituteInPlace $out/$replacePrefix/chrome-remote-desktop --replace /usr/bin/pkexec /run/wrappers/bin/pkexec
    substituteInPlace $out/$replacePrefix/chrome-remote-desktop --replace /usr/bin/gpasswd ${shadow}/bin/gpasswd
    substituteInPlace $out/$replacePrefix/chrome-remote-desktop --replace /usr/sbin/groupadd ${shadow}/sbin/groupadd
    substituteInPlace $out/$replacePrefix/chrome-remote-desktop --replace "os.path.isfile(DEBIAN_XSESSION_PATH)" "True"
  '' + lib.optionalString (!enableNewSession) ''
    substituteInPlace $out/$replacePrefix/chrome-remote-desktop --replace "FIRST_X_DISPLAY_NUMBER = 20" "FIRST_X_DISPLAY_NUMBER = 0"
    substituteInPlace $out/$replacePrefix/chrome-remote-desktop --replace "while os.path.exists(X_LOCK_FILE_TEMPLATE % display):" "# while os.path.exists(X_LOCK_FILE_TEMPLATE % display):"
    substituteInPlace $out/$replacePrefix/chrome-remote-desktop --replace "display += 1" "# display += 1"
    substituteInPlace $out/$replacePrefix/chrome-remote-desktop --replace "self._launch_x_server(x_args)" "display = self.get_unused_display_number()"
    substituteInPlace $out/$replacePrefix/chrome-remote-desktop --replace "if not self._launch_pre_session():" "self.child_env[\"DISPLAY\"] = \":%d\" % display"
    substituteInPlace $out/$replacePrefix/chrome-remote-desktop --replace "self.launch_x_session()" "# self.launch_x_session()"
  '';

  preFixup = let
    libPath = lib.makeLibraryPath [
      glib
      pam
      nss
      nspr
      expat
      gtk3
      dconf
      xorg.libXext
      xorg.libX11
      xorg.libXcomposite
      xorg.libXrender
      xorg.libXrandr
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXfixes
      xorg.libXi
      xorg.libXtst
      xorg.libxcb
      xorg.libXScrnSaver
      fontconfig
      dbus.daemon.lib
      alsaLib
      shadow
      mesa
      libdrm
      libxkbcommon
      wayland
    ];
  in ''
        for i in $out/$replacePrefix/{chrome-remote-desktop-host,start-host,native-messaging-host,remote-assistance-host,user-session}; do
          sed -i "s|$replacePrefix|$replaceTarget|g" $i
          patchelf --set-rpath "${libPath}" $i
          patchelf --set-interpreter ${glibc}/lib/ld-linux-x86-64.so.2 $i
        done
  '';

  meta = with lib; {
    description = "Chrome Remote Desktop";
    homepage = "https://remotedesktop.google.com/";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ sepiabrown ];
  };
}
