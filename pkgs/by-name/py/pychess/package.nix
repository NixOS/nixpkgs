{
  lib,
  python3Packages,
  fetchFromGitHub,
  pkg-config,
  gobject-introspection,
  wrapGAppsHook3,
  gtk3,
  gst_all_1,
  gtksourceview,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "pychess";
  version = "1.0.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pychess";
    repo = "pychess";
    rev = "${version}";
    hash = "sha256-hxc+vYvCeiM0+oOu1peI9qkZg5PeIsDMCiydJQAuzOk=";
  };

  nativeBuildInputs = [
    pkg-config
    gobject-introspection
    wrapGAppsHook3
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    gtk3
    gst_all_1.gst-plugins-base
    gtksourceview
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    pycairo
    sqlalchemy
    pexpect
    psutil
    websockets
    ptyprocess
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  preBuild = ''
    export PYTHONPATH=./lib:$PYTHONPATH
    python pgn2ecodb.py
    python create_theme_preview.py
  '';

  postInstall = ''
    cp -r $out/share/pychess/* $out/lib/python*/
  '';

  # No tests available.
  doCheck = false;

  meta = {
    description = "Advanced GTK chess client written in Python";
    homepage = "https://pychess.github.io/";
    mainProgram = "pychess";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ lgbishop ];
  };
}
