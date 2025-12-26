{
  lib,
  fetchFromGitea,
  gdk-pixbuf,
  gobject-introspection,
  gtk3,
  libnotify,
  libsecret,
  networkmanager,
  python3Packages,
  wrapGAppsHook3,
}:

python3Packages.buildPythonApplication rec {
  pname = "eduvpn-client";
  version = "4.6.0";
  format = "pyproject";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "eduVPN";
    repo = "linux-app";
    rev = version;
    hash = "sha256-oI/hc1XAddXGtwaLY6+zFoshs82lDTRESF4+xUmi+jc=";
  };

  nativeBuildInputs = [
    gdk-pixbuf
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libnotify
    libsecret
    networkmanager
  ];

  propagatedBuildInputs = with python3Packages; [
    eduvpn-common
    pygobject3
    setuptools
  ];

  postInstall = ''
    ln -s $out/${python3Packages.python.sitePackages}/eduvpn/data/share/ $out/share
  '';

  checkInputs = with python3Packages; [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://codeberg.org/eduVPN/linux-app/raw/tag/${version}/CHANGES.md";
    description = "Linux client for eduVPN";
    homepage = "https://codeberg.org/eduVPN/linux-app";
    license = lib.licenses.gpl3Plus;
    mainProgram = "eduvpn-gui";
    maintainers = with lib.maintainers; [
      benneti
      jwijenbergh
    ];
    platforms = lib.platforms.linux;
  };
}
