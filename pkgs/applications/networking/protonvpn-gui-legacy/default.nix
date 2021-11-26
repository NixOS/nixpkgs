{ lib
, buildPythonApplication
, fetchFromGitHub
, copyDesktopItems
, makeDesktopItem
, wrapGAppsHook
, gobject-introspection
, imagemagick
, libappindicator-gtk3
, libnotify
, procps
, protonvpn-cli
, openvpn
# Python libraries
, configparser
, pycairo
, pygobject3
, requests }:

buildPythonApplication rec {
  pname = "protonvpn-gui-legacy";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "calexandru2018";
    repo = "linux-gui-legacy";
    rev = "v${version}";
    sha256 = "avo5/2eq53HSHCnnjtxrsmpURtHvxmLZn2BxActImGY=";
  };

  desktopItems = [
    (makeDesktopItem {
      name = "ProtonVPN";
      desktopName = "ProtonVPN GUI";
      type = "Application";
      exec = "protonvpn-gui";
      icon = "protonvpn";
      categories = "Network;";
      terminal = "false";
    })
    (makeDesktopItem {
      name = "ProtonVPN Tray";
      desktopName = "ProtonVPN Tray";
      type = "Application";
      exec = "protonvpn-tray";
      icon = "protonvpn";
      categories = "Network;";
      terminal = "false";
    })
  ];

  nativeBuildInputs = [
    copyDesktopItems
    gobject-introspection
    imagemagick
    wrapGAppsHook
  ];

  propagatedBuildInputs = [
    configparser
    # Although built as an Python application, it is also a package,
    # hence it is needed here
    protonvpn-cli
    pycairo
    pygobject3
    requests
  ];

  buildInputs = [
    gobject-introspection
    libnotify
    libappindicator-gtk3
    procps
    openvpn
  ];

  postInstall = ''
    # create icons
    for size in 16 32 48 64 72 96 128 192 512 1024; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      convert -resize "$size"x"$size" \
        linux_gui/resources/img/logo/protonvpn_logo.png \
        $out/share/icons/hicolor/"$size"x"$size"/apps/protonvpn.png
    done
  '';

  # No tests
  doCheck = false;

  meta = with lib; {
    description = "GTK3 GUI client with systray, for ProtonVPN (legacy)";
    homepage = "https://github.com/calexandru2018/linux-gui-legacy";
    maintainers = with maintainers; [ offline wolfangaukang ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
