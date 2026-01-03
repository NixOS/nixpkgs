{
  lib,
  fetchFromGitHub,
  gettext,
  ninja,
  meson,
  sassc,
  python3Packages,
  gobject-introspection,
  wrapGAppsHook3,
  libayatana-appindicator,
  libxcb,
  qt6Packages,
  ibus,
  usbutils,
  psmisc,
}:

python3Packages.buildPythonApplication rec {
  pname = "polychromatic";
  version = "0.9.3";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "polychromatic";
    repo = "polychromatic";
    tag = "v${version}";
    hash = "sha256-fw4XLaivf8kRkNaemHvd9zcVKn87ZZhP+ZDJsCJHv/4=";
  };

  postPatch = ''
    patchShebangs scripts
    substituteInPlace scripts/build-styles.sh \
      --replace-fail '$(which sassc 2>/dev/null)' '${sassc}/bin/sassc' \
      --replace-fail '$(which sass 2>/dev/null)' '${sassc}/bin/sass'
    substituteInPlace polychromatic/paths.py \
      --replace-fail "/usr/share/polychromatic" "$out/share/polychromatic"
  '';

  preConfigure = ''
    scripts/build-styles.sh
  '';

  nativeBuildInputs = [
    gettext
    gobject-introspection
    meson
    ninja
    sassc
    wrapGAppsHook3
    qt6Packages.wrapQtAppsHook
    qt6Packages.qtbase
  ];

  buildInputs = [ qt6Packages.qtwayland ];

  propagatedBuildInputs =
    with python3Packages;
    [
      colorama
      colour
      openrazer
      pyqt6
      pyqt6-webengine
      requests
      setproctitle
      libxcb
      openrazer-daemon
      ibus
      usbutils
    ]
    ++ [
      libayatana-appindicator
      psmisc
    ];

  dontWrapGApps = true;
  dontWrapQtApps = true;

  makeWrapperArgs = [
    "\${gappsWrapperArgs[@]}"
    "\${qtWrapperArgs[@]}"
  ];

  meta = {
    homepage = "https://polychromatic.app/";
    description = "Graphical front-end and tray applet for configuring Razer peripherals on GNU/Linux";
    longDescription = ''
      Polychromatic is a frontend for OpenRazer that enables Razer devices
      to control lighting effects and more on GNU/Linux.
    '';
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ evanjs ];
    mainProgram = "polychromatic-controller";
  };
}
