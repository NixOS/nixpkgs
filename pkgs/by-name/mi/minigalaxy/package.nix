{
  lib,
  fetchFromGitHub,
  glibcLocales,
  glib-networking,
  gobject-introspection,
  gtk3,
  libnotify,
  python3Packages,
  steam-run,
  substituteAll,
  unzip,
  webkitgtk_4_0,
  wrapGAppsHook3,
}:

python3Packages.buildPythonApplication rec {
  pname = "minigalaxy";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "sharkwouter";
    repo = "minigalaxy";
    tag = version;
    hash = "sha256-nxWJm+CkxZqRMUYQA0ZJKOb2fD1tPYXnYhy+DOnDbkQ=";
  };

  patches = [
    (substituteAll {
      src = ./inject-launcher-steam-run.diff;
      steamrun = lib.getExe steam-run;
    })
  ];

  postPatch = ''
    substituteInPlace minigalaxy/installer.py \
      --replace-fail '"unzip"' "\"${lib.getExe unzip}\"" \
      --replace-fail "'unzip'" "\"${lib.getExe unzip}\""
  '';

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    glib-networking
    gtk3
    libnotify
  ];

  nativeCheckInputs = with python3Packages; [
    glibcLocales
    pytestCheckHook
    simplejson
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonPath = [
    python3Packages.pygobject3
    python3Packages.requests
    webkitgtk_4_0
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    homepage = "https://sharkwouter.github.io/minigalaxy/";
    changelog = "https://github.com/sharkwouter/minigalaxy/blob/${version}/CHANGELOG.md";
    downloadPage = "https://github.com/sharkwouter/minigalaxy/releases";
    description = "Simple GOG client for Linux";
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
