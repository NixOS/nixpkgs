{ stdenv, lib, fetchurl, dpkg
, alsa-lib, atk, cairo, cups, dbus, expat, fontconfig, freetype
, gdk-pixbuf, glib, pango, nspr, nss, gtk3, mesa
, xorg, autoPatchelfHook, systemd, libnotify, libappindicator
, makeWrapper
}:

let deps = [
    alsa-lib
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    pango
    gtk3
    libappindicator
    libnotify
    mesa
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
    xorg.libxshmfence
    nspr
    nss
    systemd
  ];

in

stdenv.mkDerivation rec {
  pname = "mullvad-vpn";
  version = "2022.5";

  src =
    let
      inherit (stdenv.hostPlatform) system;
      selectSystem = attrs: attrs.${system} or (throw "Unsupported system: ${system}");
      suffix = selectSystem {
        x86_64-linux = "amd64";
        aarch64-linux = "arm64";
      };
      sha256 = selectSystem {
        x86_64-linux = "sha256-G3B4kb+ugukYtCVH3HHI43u3n9G0dX6WyYUA3X/sZ+o=";
        aarch64-linux = "sha256-bDenh7OU9RfU6bOMy0GTBMM9KOfiqXxligNVPLcNE3A=";
      };
    in
    fetchurl {
      url = "https://github.com/mullvad/mullvadvpn-app/releases/download/${version}/MullvadVPN-${version}_${suffix}.deb";
      inherit sha256;
    };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
  ];

  buildInputs = deps;

  dontBuild = true;
  dontConfigure = true;

  unpackPhase = "dpkg-deb -x $src .";

  runtimeDependencies = [ (lib.getLib systemd) libnotify libappindicator ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/mullvad $out/bin

    mv usr/share/* $out/share
    mv usr/bin/* $out/bin
    mv opt/Mullvad\ VPN/* $out/share/mullvad

    ln -s $out/share/mullvad/mullvad-{gui,vpn} $out/bin/
    ln -sf $out/share/mullvad/resources/mullvad-problem-report $out/bin/mullvad-problem-report

    wrapProgram $out/bin/mullvad-vpn --set MULLVAD_DISABLE_UPDATE_NOTIFICATION 1

    sed -i "s|Exec.*$|Exec=$out/bin/mullvad-vpn $U|" $out/share/applications/mullvad-vpn.desktop

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    homepage = "https://github.com/mullvad/mullvadvpn-app";
    description = "Client for Mullvad VPN";
    changelog = "https://github.com/mullvad/mullvadvpn-app/blob/${version}/CHANGELOG.md";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.gpl3Only;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ Br1ght0ne ymarkus ataraxiasjel ];
  };

}
