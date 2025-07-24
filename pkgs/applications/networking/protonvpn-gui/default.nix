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
  version = "4.9.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "proton-vpn-gtk-app";
    tag = "v${version}";
    hash = "sha256-xpMXpYLLui+1bjK72VPhUT6T/sYpoqN2Jz6sczKJO5U=";
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

  postInstall = ''
    mkdir -p $out/share/{applications,pixmaps}
    install -Dm 644 ${src}/rpmbuild/SOURCES/protonvpn-app.desktop $out/share/applications
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
