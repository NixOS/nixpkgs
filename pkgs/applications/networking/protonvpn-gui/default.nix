{ lib
, buildPythonApplication
, fetchFromGitHub
, gobject-introspection
, setuptools
, wrapGAppsHook
, dbus-python
, packaging
, proton-core
, proton-keyring-linux
, proton-keyring-linux-secretservice
, proton-vpn-api-core
, proton-vpn-connection
, proton-vpn-killswitch
, proton-vpn-killswitch-network-manager
, proton-vpn-logger
, proton-vpn-network-manager
, proton-vpn-network-manager-openvpn
, proton-vpn-session
, pycairo
, pygobject3
, pytestCheckHook
, withIndicator ? true
, libappindicator-gtk3
, libayatana-appindicator
}:

buildPythonApplication rec {
  pname = "protonvpn-gui";
  version = "4.1.0-unstable-2023-10-25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "proton-vpn-gtk-app";
    rev = "713324e9e4ee9f030c8115072cae379eb3340c42";
    hash = "sha256-DfuM4b2cSIA8j9Ux3TzInRCvzQGb9LvJDSwRhfadBPY=";
  };

  nativeBuildInputs = [
    # Needed for the NM namespace
    gobject-introspection
    setuptools
    wrapGAppsHook
  ];

  buildInputs = lib.optionals withIndicator [
    # Adds AppIndicator3 namespace
    libappindicator-gtk3
    # Adds AyatanaAppIndicator3 namespace
    libayatana-appindicator
  ];

  propagatedBuildInputs = [
    dbus-python
    packaging
    proton-core
    proton-keyring-linux
    proton-keyring-linux-secretservice
    proton-vpn-api-core
    proton-vpn-connection
    proton-vpn-killswitch
    proton-vpn-killswitch-network-manager
    proton-vpn-logger
    proton-vpn-network-manager
    proton-vpn-network-manager-openvpn
    proton-vpn-session
    pycairo
    pygobject3
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=proton --cov-report=html --cov-report=term" ""
  '';

  postInstall = ''
    mkdir -p $out/share/{applications,pixmaps}
    install -Dm 644 ${src}/rpmbuild/SOURCES/protonvpn-app.desktop $out/share/applications
    install -Dm 644 ${src}/rpmbuild/SOURCES/proton-vpn-logo.svg $out/share/pixmaps
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    # Needed for Permission denied: '/homeless-shelter'
    export HOME=$(mktemp -d)
  '';

  # Gets a segmentation fault after the widgets test
  doCheck = false;

  meta = with lib; {
    description = "Proton VPN GTK app for Linux";
    homepage = "https://github.com/ProtonVPN/proton-vpn-gtk-app";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "protonvpn-app";
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
