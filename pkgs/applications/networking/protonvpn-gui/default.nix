{ lib, fetchFromGitHub, makeDesktopItem, makeWrapper, imagemagick
, python3Packages, wrapGAppsHook, protonvpn-cli, gtk3, pango
, gobject-introspection, libnotify, libappindicator-gtk3
, procps, openvpn }:

let
  extraPath = lib.makeBinPath [ procps openvpn ];

in python3Packages.buildPythonApplication rec {
  pname = "protonvpn-linux-gui";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "protonvpn";
    repo = "linux-gui";
    rev = "v${version}";
    sha256 = "avo5/2eq53HSHCnnjtxrsmpURtHvxmLZn2BxActImGY=";
  };

  desktopItem = makeDesktopItem {
    name = "ProtonVPN";
    desktopName = "ProtonVPN GUI";
    type = "Application";
    exec = "protonvpn-gui";
    icon = "protonvpn";
    categories = "Network;";
    terminal = "false";
  };

  trayDesktopItem = makeDesktopItem {
    name = "ProtonVPN Tray";
    desktopName = "ProtonVPN Tray";
    type = "Application";
    exec = "protonvpn-tray";
    icon = "protonvpn";
    categories = "Network;";
    terminal = "false";
  };

  nativeBuildInputs = [ wrapGAppsHook makeWrapper imagemagick ];

  propagatedBuildInputs = (with python3Packages; [
      pygobject3
      pycairo
      requests
      configparser
    ]) ++ [
      protonvpn-cli
      gtk3
      gobject-introspection
      libnotify
      libappindicator-gtk3
    ];

  prePatch = ''
    # if pkexec is used, we want to have more time to enter password
    substituteInPlace linux_gui/services/login_service.py --replace 'timeout=8' 'timeout=30'
  '';

  postInstall = ''
    # wrap binaries with extra required path
    wrapProgram "$out/bin/protonvpn-tray" --prefix PATH ":" ${extraPath}
    wrapProgram "$out/bin/protonvpn-gui" --prefix PATH ":" ${extraPath}

    # install desktop files
    mkdir -p $out/share/applications
    cp "$desktopItem/share/applications/ProtonVPN.desktop" $out/share/applications/protonvpn-gui.desktop
    cp "$trayDesktopItem/share/applications/ProtonVPN Tray.desktop" $out/share/applications/protonvpn-tray.desktop

    # create icons
    for size in 16 32 48 64 72 96 128 192 512 1024; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      convert -resize "$size"x"$size" \
        linux_gui/resources/img/logo/protonvpn_logo.png \
        $out/share/icons/hicolor/"$size"x"$size"/apps/protonvpn.png
    done
  '';

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Linux GUI for ProtonVPN, written in Python";
    homepage = "https://github.com/ProtonVPN/linux-gui";
    maintainers = with maintainers; [ offline ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
