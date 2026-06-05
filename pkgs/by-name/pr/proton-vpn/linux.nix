{
  lib,
  meta,
  python3Packages,
  fetchFromGitHub,
  gobject-introspection,
  libappindicator-gtk3,
  libayatana-appindicator,
  libnotify,
  wrapGAppsHook4,
  writableTmpDirAsHomeHook,
  nix-update-script,
  withIndicator ? true,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "proton-vpn";
  version = "4.15.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "proton-vpn-gtk-app";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2v8BckNmm7Ecw+uAgOyfofHDPWgXkJJ8DmhMszb0tg0=";
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
    mkdir -p $out/share/applications

    # Fix the desktop file to correctly identify the wrapped app and show the icon during runtime
    substitute ${finalAttrs.src}/rpmbuild/SOURCES/proton.vpn.app.gtk.desktop $out/share/applications/proton.vpn.app.gtk.desktop \
      --replace-fail "StartupWMClass=protonvpn-app" "StartupWMClass=.protonvpn-app-wrapped"
    install -Dm444 ${finalAttrs.src}/rpmbuild/SOURCES/proton-vpn-logo.svg -t $out/share/icons/hicolor/scalable/apps
  '';

  preCheck = ''
    export XDG_RUNTIME_DIR=$(mktemp -d)
  '';

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ]
  ++ (with python3Packages; [
    pytestCheckHook
    pytest-cov-stub
  ]);

  disabledTestPaths = [
    # Segmentation fault during widgets tests
    "tests/unit/widgets"
  ];

  passthru.updateScript = nix-update-script { };

  meta = meta // {
    platforms = lib.platforms.linux;
    mainProgram = "protonvpn-app";
  };
})
