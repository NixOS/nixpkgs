{
  lib,
  fetchFromCodeberg,
  gdk-pixbuf,
  gobject-introspection,
  gtk3,
  libnotify,
  libsecret,
  networkmanager,
  python3Packages,
  wrapGAppsHook3,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "eduvpn-client";
  version = "4.7.2";
  pyproject = true;

  src = fetchFromCodeberg {
    owner = "eduVPN";
    repo = "linux-app";
    tag = finalAttrs.version;
    hash = "sha256-vJZ2C4z5qB5wWwl9LPyaDj60Lne1jcbLml/4Q5tTC/o=";
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

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    eduvpn-common
    pygobject3
  ];

  postInstall = ''
    ln -s $out/${python3Packages.python.sitePackages}/eduvpn/data/share/ $out/share
  '';

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];

  meta = {
    changelog = "https://codeberg.org/eduVPN/linux-app/raw/tag/${finalAttrs.version}/CHANGES.md";
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
})
