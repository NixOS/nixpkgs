{ stdenv
, lib
, fetchurl
, dpkg
, alsa-lib
, atk
, cairo
, cups
, dbus
, expat
, fontconfig
, freetype
, gdk-pixbuf
, glib
, pango
, nspr
, nss
, gtk3
, mesa
, libGL
, wayland
, xorg
, autoPatchelfHook
, systemd
, libnotify
, libappindicator
, makeWrapper
, coreutils
, gnugrep
}:

let
  deps = [
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

  version = "2023.5";

  selectSystem = attrs: attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  platform = selectSystem {
    x86_64-linux = "amd64";
    aarch64-linux = "arm64";
  };

  hash = selectSystem {
    x86_64-linux = "sha256-FpVruI80PmpBo2JrMvgvOg7ou6LceTeit9HbWKgcPa4=";
    aarch64-linux = "sha256-NlYh8K5Xbad4xSoZ02yC5fh3SrQzyNyS9uoA73REcpo=";
  };
in

stdenv.mkDerivation {
  pname = "mullvad-vpn";
  inherit version;

  src = fetchurl {
    url = "https://github.com/mullvad/mullvadvpn-app/releases/download/${version}/MullvadVPN-${version}_${platform}.deb";
    inherit hash;
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

  runtimeDependencies = [ (lib.getLib systemd) libGL libnotify libappindicator wayland ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/mullvad $out/bin

    mv usr/share/* $out/share
    mv usr/bin/* $out/bin
    mv opt/Mullvad\ VPN/* $out/share/mullvad

    ln -s $out/share/mullvad/mullvad-{gui,vpn} $out/bin/
    ln -sf $out/share/mullvad/resources/mullvad-problem-report $out/bin/mullvad-problem-report

    wrapProgram $out/bin/mullvad-vpn \
      --set MULLVAD_DISABLE_UPDATE_NOTIFICATION 1 \
      --prefix PATH : ${lib.makeBinPath [ coreutils gnugrep ]}

    wrapProgram $out/bin/mullvad-daemon \
        --set-default MULLVAD_RESOURCE_DIR "$out/share/mullvad/resources"

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
