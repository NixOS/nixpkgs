{ stdenv, makeWrapper, fetchurl, dpkg
, alsaLib, atk, cairo, cups, dbus, expat, fontconfig, freetype
, gdk_pixbuf, glib, gnome2, pango, nspr, nss, gtk3
, xorg, autoPatchelfHook, systemd, libnotify
}:

let deps = [
    alsaLib
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk_pixbuf
    glib
    gnome2.GConf
    pango
    gtk3
    libnotify
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libxcb
    nspr
    nss
    systemd
  ];

in

stdenv.mkDerivation rec {
  pname = "mullvad-vpn";
  version = "2019.5";

  src = fetchurl {
    url = "https://www.mullvad.net/media/app/MullvadVPN-${version}_amd64.deb";
    sha256 = "542a93521906cd5e97075c9f3e9088c19562b127556a3de151e25bc66b11fe0b";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = deps;

  dontBuild = true;
  dontConfigure = true;

  unpackPhase = "dpkg-deb -x $src .";

  runtimeDependencies = [ systemd.lib libnotify ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/mullvad $out/bin

    mv usr/share/* $out/share
    mv usr/bin/* $out/bin
    mv opt/Mullvad\ VPN/* $out/share/mullvad

    sed -i 's|\/opt\/Mullvad.*VPN|'$out'/bin|g' $out/share/applications/mullvad-vpn.desktop
    sed -i 's|\/opt\/Mullvad.*VPN/resources|'$out'/bin|g' $out/share/mullvad/resources/mullvad-daemon.service

    ln -s $out/share/mullvad/mullvad-vpn $out/bin/mullvad-vpn
    ln -s $out/share/mullvad/resources/mullvad-daemon $out/bin/mullvad-daemon

    mkdir -p $out/etc/systemd/system
    ln -s $out/share/mullvad/resources/mullvad-daemon.service $out/etc/systemd/system/mullvad-daemon.service

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/mullvad/mullvadvpn-app";
    description = "Client for Mullvad VPN";
    changelog = "https://github.com/mullvad/mullvadvpn-app/blob/${version}/CHANGELOG.md";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
  };

}
