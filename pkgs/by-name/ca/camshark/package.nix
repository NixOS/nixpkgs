{
  lib,
  stdenv,
  fetchFromGitLab,
  python3Packages,
  gtk4,
  libadwaita,
  wrapGAppsHook4,
  qt5,
  xorg,
}:

python3Packages.buildPythonApplication rec {
  pname = "camshark";
  version = "0.2.3";

  format = "pyproject";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "camera";
    repo = "camshark";
    rev = "v${version}";
    sha256 = "sha256-92jmNfoi6JN9xrH3i8dDEsUI+OtXaDXmihb+iUflNLI=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [
    python3Packages.setuptools
    python3Packages.wheel
    wrapGAppsHook4
  ];

  propagatedBuildInputs =
    with python3Packages;
    [
      pygobject3
      coloredlogs
      colour
      numpy
      opencv4
      pyqt5
      pyqtgraph
      qscintilla
      opencv-python
      pidng
      pixutils
      pyyaml
    ]
    ++ [
      gtk4
      libadwaita
      qt5.qtbase
      qt5.qtsvg
      qt5.qtwayland
      qt5.qtbase.dev
      xorg.libXext
      xorg.libXrender
      qt5.qtbase.dev
      xorg.libX11
      xorg.libxcb
      xorg.xcbutil
      xorg.xcbutilimage
      xorg.xcbutilkeysyms
      xorg.xcbutilrenderutil
    ];

  postPatch = ''
    sed -i '/colour-science/d' pyproject.toml
    sed -i '/opencv-contrib-python/d' pyproject.toml
  '';

  preFixup = ''
    wrapProgram $out/bin/camshark \
      --set QT_QPA_PLATFORM_PLUGIN_PATH ${qt5.qtbase}/${qt5.qtbase.qtPluginPrefix}/platforms \
      --set QT_PLUGIN_PATH ${qt5.qtbase}/${qt5.qtbase.qtPluginPrefix}
  '';

  pythonImportsCheck = [ "camshark" ];

  meta = with lib; {
    description = "A GTK4 + libadwaita GStreamer camera debug tool";
    homepage = "https://gitlab.freedesktop.org/camera/camshark";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ phodina ];
    platforms = platforms.linux;
  };
}
