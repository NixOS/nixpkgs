{
  lib,
  python3Packages,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  gettext,
  libxml2,
  desktop-file-utils,
  gobject-introspection,
  wrapGAppsHook4,
  glib,
  gtk4,
  gtk3,
  libadwaita,
  libayatana-appindicator,
  libnotify,
  librsvg,
  gnome,
  android-tools,
  scrcpy,
  xdg-utils,
  xvfb,
  nix-update-script,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "aurynk";
  version = "1.3.1";
  pyproject = false;

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "IshuSinghSE";
    repo = "aurynk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rQUc7J3DSghKiyaKkIyEm6E5uSgfdYZ5vUuqaYDza7U=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    libxml2
    desktop-file-utils
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    gtk3
    libadwaita
    libayatana-appindicator
    libnotify
  ];

  dependencies = with python3Packages; [
    pygobject3
    pillow
    pyudev
    qrcode
    zeroconf
  ];

  postPatch = ''
    substituteInPlace aurynk/application.py \
      --replace-fail \
        "/usr/share/aurynk/io.github.IshuSinghSE.aurynk.gresource" \
        "$out/share/aurynk/io.github.IshuSinghSE.aurynk.gresource"

    substituteInPlace scripts/aurynk_tray.py \
      --replace-fail \
        '/usr/share/aurynk/icons/' \
        "$out/share/aurynk/icons/"

    substituteInPlace aurynk/application.py \
      --replace-fail \
        'subprocess.Popen(["python3", script_path], env=env)' \
        'subprocess.Popen([sys.executable, script_path], env={**env, "PYTHONPATH": os.pathsep.join(sys.path)})'

    printf '%s\n' \
      '#!/usr/bin/env python3' \
      'import runpy' \
      'runpy.run_module("aurynk", run_name="__main__", alter_sys=True)' \
      > scripts/aurynk

    substituteInPlace aurynk/ui/windows/settings_window.py \
      --replace-fail 'exec_path = str(script_path)' 'exec_path = "aurynk"'

    substituteInPlace tests/test_usb_monitor.py \
      --replace-fail \
        'self.mock_context = Mock(name="context")' \
        $'self.mock_context = Mock(name="context")\n        self.mock_context.list_devices.return_value = []'
  '';

  postInstall = ''
    export GDK_PIXBUF_MODULE_FILE="${
      gnome._gdkPixbufCacheBuilder_DO_NOT_USE {
        extraLoaders = [ librsvg ];
      }
    }"
  '';

  pythonImportsCheck = [ "aurynk" ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    xvfb
  ];

  preCheck = ''
    cd ..
    export PYTHONPATH=$out/${python3Packages.python.sitePackages}:$PYTHONPATH
    export HOME=$TMPDIR

    export DISPLAY=:$((2000 + RANDOM % 1000))
    Xvfb $DISPLAY -screen 0 1024x768x24 &
    xvfbPid=$!

    pytest -q tests/test_usb_monitor.py
  '';

  postCheck = ''
    kill $xvfbPid
  '';

  enabledTestPaths = [ "tests/" ];

  disabledTests = [
    # Expects the --window-width command-line argument for scrcpy but the app does not add it
    "test_window_geometry_clamping"
  ];

  disabledTestPaths = [
    # These USB tests break the GTK tests if they share a process
    # Run this file in preCheck in its own pytest
    "tests/test_usb_monitor.py"
  ];

  dontWrapGApps = true;

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${
        lib.makeBinPath [
          android-tools
          scrcpy
          xdg-utils
        ]
      }
    )
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Android Mirroring Tool for Linux";
    homepage = "https://github.com/IshuSinghSE/aurynk";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ aaravrav ];
    mainProgram = "aurynk";
    platforms = lib.platforms.linux;
  };
})
