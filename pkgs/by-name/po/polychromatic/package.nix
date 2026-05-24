{
  lib,
  fetchFromGitHub,
  gettext,
  ninja,
  meson,
  python3Packages,
  gobject-introspection,
  wrapGAppsHook3,
  libayatana-appindicator,
  libxcb,
  qt6,
  ibus,
  usbutils,
  psmisc,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "polychromatic";
  version = "0.9.7";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "polychromatic";
    repo = "polychromatic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2Uo6/74o+cSQQsYsE+7nVDsetnaYjQzL8xkJhUN3E2o=";
  };

  postPatch = ''
    patchShebangs scripts
    substituteInPlace polychromatic/paths.py \
      --replace-fail "/usr/share/polychromatic" "$out/share/polychromatic"
  '';

  nativeBuildInputs = [
    gettext
    gobject-introspection
    meson
    ninja
    wrapGAppsHook3
    qt6.wrapQtAppsHook
    qt6.qtbase
  ];

  buildInputs = [ qt6.qtwayland ];

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
    changelog = "https://github.com/polychromatic/polychromatic/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      evanjs
      nadir-ishiguro
    ];
    mainProgram = "polychromatic-controller";
  };
})
