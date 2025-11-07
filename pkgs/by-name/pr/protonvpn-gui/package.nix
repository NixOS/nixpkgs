{
  lib,
  python3Packages,
  fetchFromGitHub,
  gobject-introspection,
  wrapGAppsHook3,
  libnotify,
  withIndicator ? true,
  libappindicator-gtk3,
  libayatana-appindicator,
}:

python3Packages.buildPythonApplication rec {
  pname = "protonvpn-gui";
  version = "4.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "proton-vpn-gtk-app";
    tag = "v${version}";
    hash = "sha256-pDTzqTiGAisVEHwez526z9C9GzNkMWl6Cui8E6siIXo=";
  };

  nativeBuildInputs = [
    # Needed for the NM namespace
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    libnotify # gir typelib is used
  ]
  ++ lib.optionals withIndicator [
    # Adds AppIndicator3 namespace
    libappindicator-gtk3
    # Adds AyatanaAppIndicator3 namespace
    libayatana-appindicator
  ];

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    dbus-python
    packaging
    proton-core
    proton-keyring-linux
    proton-vpn-api-core
    proton-vpn-local-agent
    proton-vpn-network-manager
    pycairo
    pygobject3
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postInstall = ''
    mkdir -p $out/share/{applications,pixmaps}

    # Fix the desktop file to correctly identify the wrapped app and show the icon during runtime
    substitute ${src}/rpmbuild/SOURCES/proton.vpn.app.gtk.desktop $out/share/applications/proton.vpn.app.gtk.desktop \
      --replace-fail "StartupWMClass=protonvpn-app" "StartupWMClass=.protonvpn-app-wrapped"
    install -Dm 644 ${src}/rpmbuild/SOURCES/proton-vpn-logo.svg $out/share/pixmaps
  '';

  preCheck = ''
    # Needed for Permission denied: '/homeless-shelter'
    export HOME=$(mktemp -d)
  '';

  # Gets a segmentation fault after the widgets test
  doCheck = false;

  meta = {
    description = "Proton VPN GTK app for Linux";
    homepage = "https://github.com/ProtonVPN/proton-vpn-gtk-app";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "protonvpn-app";
    maintainers = with lib.maintainers; [
      sebtm
      rapiteanu
    ];
  };
}
