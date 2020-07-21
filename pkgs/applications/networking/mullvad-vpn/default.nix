{ stdenv, makeWrapper, fetchurl, dpkg
, alsaLib, atk, cairo, cups, dbus, expat, fontconfig, freetype
, gdk-pixbuf, glib, gnome2, pango, nspr, nss, gtk3
, xorg, autoPatchelfHook, systemd, libnotify, libappindicator
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
    gdk-pixbuf
    glib
    gnome2.GConf
    pango
    gtk3
    libappindicator
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
  version = "2020.5";

  src = fetchurl {
    url = "https://www.mullvad.net/media/app/MullvadVPN-${version}_amd64.deb";
    sha256 = "131z6qlpjwxcn5a62f1f147f2z1xg185jmr0vbin8h0dwa1182vn";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = deps;

  dontBuild = true;
  dontConfigure = true;

  unpackPhase = "dpkg-deb -x $src .";

  runtimeDependencies = [ systemd.lib libnotify libappindicator ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/mullvad $out/bin

    mv usr/share/* $out/share
    mv usr/bin/* $out/bin
    mv opt/Mullvad\ VPN/* $out/share/mullvad

    sed -i 's|\/opt\/Mullvad.*VPN|'$out'/bin|g' $out/share/applications/mullvad-vpn.desktop

    ln -s $out/share/mullvad/mullvad-{gui,vpn} $out/bin/
    ln -s $out/share/mullvad/resources/mullvad-daemon $out/bin/mullvad-daemon
    ln -sf $out/share/mullvad/resources/mullvad-problem-report $out/bin/mullvad-problem-report

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/mullvad/mullvadvpn-app";
    description = "Client for Mullvad VPN";
    changelog = "https://github.com/mullvad/mullvadvpn-app/blob/${version}/CHANGELOG.md";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ filalex77 ];
  };

}
