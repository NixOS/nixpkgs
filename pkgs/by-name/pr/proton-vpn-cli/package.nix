{
  lib,
  fetchFromGitHub,
  python3Packages,
  gobject-introspection,
  libnotify,
  wrapGAppsNoGuiHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "proton-vpn-cli";
  version = "0.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "proton-vpn-cli";
    tag = "v${version}";
    hash = "sha256-nopkUda1XaFMroIvsf+vCXWa5aXUTEC/EhAN9Lto3Lo=";
  };

  nativeBuildInputs = [
    # Needed for the NM namespace
    gobject-introspection
    wrapGAppsNoGuiHook
  ];

  buildInputs = [
    libnotify # gir typelib is used
  ];

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    click
    dbus-fast
    packaging
    proton-core
    proton-keyring-linux
    proton-vpn-api-core
    proton-vpn-local-agent
    tabulate
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  preCheck = ''
    # Needed for Permission denied: '/homeless-shelter'
    export HOME=$(mktemp -d)
    export XDG_RUNTIME_DIR=$(mktemp -d)
  '';

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
  ];

  meta = {
    description = "Official ProtonVPN CLI Linux app";
    homepage = "https://github.com/ProtonVPN/proton-vpn-cli";
    license = lib.licenses.gpl3Plus;
    mainProgram = "protonvpn";
    maintainers = with lib.maintainers; [ anthonyroussel ];
  };
}
