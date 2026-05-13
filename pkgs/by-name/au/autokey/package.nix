{
  lib,
  python3Packages,
  fetchFromGitHub,
  wrapGAppsHook3,
  gobject-introspection,
  imagemagick,
  gtksourceview3,
  libappindicator-gtk3,
  libnotify,
  xautomation,
  xwd,
  zenity,
  wmctrl,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "autokey";
  version = "0.96.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "autokey";
    repo = "autokey";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d1WJLqkdC7QgzuYdnxYhajD3DtCpgceWCAxGrk0KKew=";
  };

  postPatch = ''
    # pyrcc5 embeds resource mtimes; preserve normalized source mtimes for reproducible wheels.
    substituteInPlace setup.py \
      --replace-fail "shutil.copy(str(icon), str(target_directory))" \
        "shutil.copy2(str(icon), str(target_directory))"
  '';

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    gtksourceview3
    libappindicator-gtk3
    libnotify
  ];

  build-system = with python3Packages; [
    setuptools
  ];

  nativeCheckInputs = with python3Packages; [
    pyqt5
    pyhamcrest
    pytestCheckHook
    pytest-cov-stub
  ];

  disabledTestPaths = [
    # Runs `git describe` during test collection.
    "tests/test_common.py"
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  dependencies = with python3Packages; [
    dbus-python
    pyinotify
    xlib
    pygobject3
    packaging
    standard-imghdr
  ];

  runtimeDeps = [
    imagemagick
    zenity
    xautomation
    xwd
    wmctrl
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(''${gappsWrapperArgs[@]} --prefix PATH : ${lib.makeBinPath finalAttrs.runtimeDeps})
  '';

  postInstall = ''
    # remove Qt version which we currently do not support
    rm $out/bin/autokey-qt $out/share/applications/autokey-qt.desktop
  '';

  meta = {
    description = "Desktop automation utility for Linux and X11";
    homepage = "https://github.com/autokey/autokey";
    changelog = "https://github.com/autokey/autokey/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ iamanaws ];
    platforms = lib.platforms.linux;
  };
})
