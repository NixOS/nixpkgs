{
  lib,
  fetchFromGitLab,
  python3,
  appstream-glib,
  blueprint-compiler,
  desktop-file-utils,
  glib,
  libxml2,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  gobject-introspection,
  libadwaita,
  librsvg,
  gtk4,
  gitUpdater,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "saldo";
  version = "0.8.0";
  pyproject = false;

  src = fetchFromGitLab {
    owner = "tabos";
    repo = "saldo";
    tag = version;
    hash = "sha256-L4xx9tYDiAoykoiqvXhkbnayYQyTVl1qgi3LBNDoWjg=";
  };

  postPatch = ''
    patchShebangs meson_post_conf.py meson_post_install.py
  '';

  nativeBuildInputs = [
    appstream-glib # for appstream-util
    blueprint-compiler
    desktop-file-utils # for desktop-file-validate
    glib # for glib-compile-resources
    libxml2 # for xmllint
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    gobject-introspection
    gtk4 # for gtk4-update-icon-cache
  ];

  buildInputs = [
    libadwaita
    librsvg
  ];

  dependencies = with python3.pkgs; [
    cryptography
    fints
    mt-940
    onetimepad
    pygobject3
    schwifty
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Banking application for small screens";
    homepage = "https://www.tabos.org/projects/saldo/";
    license = licenses.gpl3Plus;
    mainProgram = "org.tabos.saldo";
    maintainers = with maintainers; [ dotlambda ];
  };
}
