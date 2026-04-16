{
  lib,
  python3Packages,
  fetchFromGitHub,
  zip,
  wrapGAppsHook3,
  gobject-introspection,
  gtksourceview3,
  libappindicator-gtk3,
  libnotify,
  libsForQt5,
  zenity,
  wmctrl,
  kdePackages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "autokey-wayland";
  version = "0.97.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dlk3";
    repo = "autokey-wayland";
    rev = "v${finalAttrs.version}";
    hash = "sha256-aS1X+YKV5VtuMUjkkQIwARPWxoagXHKUFaPuy3qq/fI=";
  };

  nativeBuildInputs = [
    zip
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    gtksourceview3
    libappindicator-gtk3
    libnotify
  ];

  propagatedBuildInputs = with python3Packages; [
    # shared with upstream autokey
    dbus-python
    pyinotify
    xlib
    pygobject3
    packaging
    # wayland fork additions
    python-magic
    pyasyncore
    pyqt5
    qscintilla
    pydbus
    pyudev
    evdev
  ];

  # build the GNOME Shell extension zip before the Python build
  preBuild = ''
    cd autokey-gnome-extension
    zip --junk-paths autokey-gnome-extension@autokey.shell-extension.zip 46/extension.js 46/metadata.json
    cd ..
  '';

  runtimeDeps = [
    zenity
    wmctrl
    kdePackages.kdialog
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --prefix PATH : ${lib.makeBinPath finalAttrs.runtimeDeps}
      --prefix QT_PLUGIN_PATH : "${libsForQt5.qtbase.bin}/${libsForQt5.qtbase.qtPluginPrefix}"
      --prefix QT_PLUGIN_PATH : "${libsForQt5.qtwayland.bin}/${libsForQt5.qtbase.qtPluginPrefix}"
    )
  '';

  doCheck = false;

  meta = {
    description = "Desktop automation utility for Linux with Wayland support";
    homepage = "https://github.com/dlk3/autokey-wayland";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ enderbsd ];
    platforms = lib.platforms.linux;
    mainProgram = "autokey-qt";
  };
})
