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
  qt6,
  ibus,
  usbutils,
  psmisc,
}:

python3Packages.buildPythonApplication rec {
  pname = "polychromatic";
  version = "0.9.1";
  format = "other";

  src = fetchFromGitHub {
    owner = "polychromatic";
    repo = "polychromatic";
    rev = "v${version}";
    hash = "sha256-3Pt1Z8G0xDWlFD7LxJILPUifMBTN4OvPNHZv80umO1s=";
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
    qt6.wrapQtAppsHook
    qt6.qtbase
  ];

  buildInputs = [ qt6.qtwayland ];

  propagatedBuildInputs = with python3Packages; [
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
  ] ++ [
    libayatana-appindicator
    psmisc
  ];

  dontWrapGApps = true;
  dontWrapQtApps = true;

  makeWrapperArgs = [
    "\${gappsWrapperArgs[@]}"
    "\${qtWrapperArgs[@]}"
  ];

  meta = with lib; {
    homepage = "https://polychromatic.app/";
    description = "Graphical front-end and tray applet for configuring Razer peripherals on GNU/Linux";
    longDescription = ''
      Polychromatic is a frontend for OpenRazer that enables Razer devices
      to control lighting effects and more on GNU/Linux.
    '';
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ evanjs ];
    mainProgram = "polychromatic-controller";
  };
}
