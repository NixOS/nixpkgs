{
  fetchFromGitHub,
  glib-networking,
  glibcLocales,
  gobject-introspection,
  gtk3,
  innoextract,
  lib,
  libnotify,
  nix-update-script,
  python3Packages,
  replaceVars,
  umu-launcher,
  unzip,
  webkitgtk_4_1,
  wrapGAppsHook3,
  xdg-utils,
}:

python3Packages.buildPythonApplication rec {
  pname = "minigalaxy";
  version = "1.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sharkwouter";
    repo = "minigalaxy";
    tag = version;
    hash = "sha256-qq5XLWmQ0x6/hK8beKxJDxHmbu//EuukuyOG+CpF9ug=";
  };

  patches = [
    (replaceVars ./inject-launcher-umu-run.diff {
      umurun = lib.getExe umu-launcher;
    })
  ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
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
          innoextract
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
