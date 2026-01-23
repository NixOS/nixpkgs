{
  lib,
  fetchFromGitHub,
  glibcLocales,
  glib-networking,
  gobject-introspection,
  gtk3,
  libnotify,
  nix-update-script,
  python3Packages,
  steam-run,
  replaceVars,
  unzip,
  webkitgtk_4_1,
  wrapGAppsHook3,
  xdg-utils,
}:

python3Packages.buildPythonApplication rec {
  pname = "minigalaxy";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sharkwouter";
    repo = "minigalaxy";
    tag = version;
    hash = "sha256-ZHTjppdLxKDURceonbH7dJz+krBhu3lr2P7QPVDxRZw=";
  };

  patches = [
    (replaceVars ./inject-launcher-steam-run.diff {
      steamrun = lib.getExe steam-run;
    })
  ];

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    glib-networking
    gtk3
    libnotify
    webkitgtk_4_1
  ];

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    pygobject3
    requests
  ];

  nativeCheckInputs = with python3Packages; [
    glibcLocales
    pytestCheckHook
    simplejson
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --suffix PATH : "${
        lib.makeBinPath [
          unzip
          xdg-utils
        ]
      }"
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://sharkwouter.github.io/minigalaxy/";
    changelog = "https://github.com/sharkwouter/minigalaxy/blob/${version}/CHANGELOG.md";
    downloadPage = "https://github.com/sharkwouter/minigalaxy/releases";
    description = "Simple GOG client for Linux";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ RoGreat ];
    platforms = lib.platforms.linux;
  };
}
