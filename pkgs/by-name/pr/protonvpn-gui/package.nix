{
  lib,
  python3Packages,
  fetchFromGitHub,
  gobject-introspection,
  libappindicator-gtk3,
  libayatana-appindicator,
  libnotify,
  wrapGAppsHook4,
  withIndicator ? true,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "protonvpn-gui";
  version = "4.14.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "proton-vpn-gtk-app";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0VshVHhJlxMb31L/gF3ujvGnsH6IMtMGwdvEpdXDwiQ=";
  };

  nativeBuildInputs = [
    # Needed for the NM namespace
    gobject-introspection
    wrapGAppsHook4
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
    substitute ${finalAttrs.src}/rpmbuild/SOURCES/proton.vpn.app.gtk.desktop $out/share/applications/proton.vpn.app.gtk.desktop \
      --replace-fail "StartupWMClass=protonvpn-app" "StartupWMClass=.protonvpn-app-wrapped"
    install -Dm 644 ${finalAttrs.src}/rpmbuild/SOURCES/proton-vpn-logo.svg $out/share/pixmaps
  '';

  preCheck = ''
    # Needed for Permission denied: '/homeless-shelter'
    export HOME=$(mktemp -d)
    export XDG_RUNTIME_DIR=$(mktemp -d)
  '';

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-cov-stub
  ];

  disabledTestPaths = [
    # Segmentation fault during widgets tests
    "tests/unit/widgets"
  ];

  meta = {
    description = "Proton VPN GTK app for Linux";
    homepage = "https://github.com/ProtonVPN/proton-vpn-gtk-app";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "protonvpn-app";
    maintainers = with lib.maintainers; [
      anthonyroussel
      sebtm
      rapiteanu
    ];
  };
})
