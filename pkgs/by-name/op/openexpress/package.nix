{
  lib,
  python3Packages,
  fetchFromGitHub,
  _7zz,
  adwaita-fonts,
  adwaita-icon-theme,
  appstream,
  dbus,
  desktop-file-utils,
  gettext,
  glib-networking,
  gobject-introspection,
  gvfs,
  isocodes,
  libadwaita,
  libusb1,
  librsvg,
  libshumate,
  makeFontsConf,
  nix-update-script,
  webkitgtk_6_0,
  wrapGAppsHook4,
  xvfb,
}:

let
  appId = "io.github.tomaszbojanowski.OpenExpress";
in
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "openexpress";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TomaszBojanowski";
    repo = "openExpress";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Utb454p3TdKYcEqrPbxdquFqt4ULi0UsX8IsUjeJZm4=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  nativeBuildInputs = [
    gettext
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [
    glib-networking
    gvfs
    isocodes
    libadwaita
    librsvg
    libshumate
    webkitgtk_6_0
  ];

  nativeCheckInputs = [
    appstream
    dbus
    desktop-file-utils
    libusb1
    python3Packages.pytestCheckHook
    python3Packages.pytest-xdist
    xvfb
  ];

  dependencies = with python3Packages; [
    pygobject3
    requests
  ];

  optional-dependencies = with python3Packages; {
    music = [ mutagen ];
  };

  # The map tests create Garmin/Maps while the fake device uses GARMIN, and
  # the last-sync test drops the Nix PYTHONPATH in its subprocess. Patch both
  # so the suite runs here.
  postPatch = ''
    substituteInPlace tests/test_last_sync.py \
      --replace-fail 'env={**os.environ, "PYTHONPATH": str(root)}' 'env={**os.environ}'

    substituteInPlace tests/test_write_cleanup.py \
      --replace-fail 'device_root / "Garmin" / "Maps"' 'device_root / "GARMIN" / "Maps"' \
      --replace-fail 'Cannot write Garmin/Maps/abc.gma' 'Cannot write GARMIN/Maps/abc.gma'

    # The app's fixed /usr/share path does not exist on NixOS.
    substituteInPlace openexpress/i18n.py \
      --replace-fail 'Path("/usr/share/iso-codes/json/iso_3166-1.json")' 'Path("${isocodes}/share/iso-codes/json/iso_3166-1.json")'
  '';

  preBuild = ''
    # Compile the .po catalogs and the translated metainfo.
    python -m openexpress.catalogs

    python -c 'from openexpress.desktop import desktop_entry; print(desktop_entry("openexpress gui"), end="")' > ${appId}.desktop
    sed -i '/^StartupNotify/a StartupWMClass=${appId}' ${appId}.desktop
  '';

  preCheck = ''
    export FONTCONFIG_FILE=${makeFontsConf { fontDirectories = [ adwaita-fonts ]; }}
    export LD_LIBRARY_PATH=${lib.makeLibraryPath [ libusb1 ]}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
    desktop-file-validate ${appId}.desktop
  '';

  pytestFlags = [ "--maxprocesses=8" ];

  disabledTestPaths = [
    # test_applog.py measures redact() in wall-clock time; run it serially so
    # the xdist workers' CPU contention cannot fail its 2-second budget.
    "tests/test_applog.py"
  ];

  postCheck = ''
    python3 -m pytest tests/test_applog.py
  '';

  dontWrapGApps = true;

  preFixup = ''
    # The icon theme is not in the wrapper's XDG_DATA_DIRS otherwise.
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "${adwaita-icon-theme}/share")
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ _7zz ])
    "--prefix"
    "LD_LIBRARY_PATH"
    ":"
    (lib.makeLibraryPath [ libusb1 ])
  ];

  postInstall = ''
    install -Dm644 ${appId}.desktop $out/share/applications/${appId}.desktop
    install -Dm644 openexpress/data/${appId}.svg \
      $out/share/icons/hicolor/scalable/apps/${appId}.svg
    install -Dm644 openexpress/data/${appId}-symbolic.svg \
      $out/share/icons/hicolor/symbolic/apps/${appId}-symbolic.svg
    install -Dm644 openexpress/data/${appId}.metainfo.xml \
      $out/share/metainfo/${appId}.metainfo.xml
  '';

  pythonImportsCheck = [ "openexpress" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Unofficial Linux app for Garmin watches: Garmin Connect sync, software updates, maps, Connect IQ apps and music over USB";
    homepage = "https://github.com/TomaszBojanowski/openExpress";
    changelog = "https://github.com/TomaszBojanowski/openExpress/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    mainProgram = "openexpress";
    platforms = lib.platforms.linux;
  };
})
