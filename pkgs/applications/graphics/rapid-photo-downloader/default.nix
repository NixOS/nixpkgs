{
  lib,
  fetchFromGitHub,
  python3Packages,
  libsForQt5,
  file,
  intltool,
  gobject-introspection,
  libgudev,
  udisks,
  gexiv2,
  gst_all_1,
  libnotify,
  ifuse,
  libimobiledevice,
  exiftool,
  gdk-pixbuf,
  libmediainfo,
  vmtouch,
  gitUpdater,
}:

python3Packages.buildPythonApplication rec {
  pname = "rapid-photo-downloader";
  version = "0.9.36";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "damonlynch";
    repo = "rapid-photo-downloader";
    rev = "v${version}";
    hash = "sha256-fFmIbqymYkg2Z1/x0mNsCNlDCOyqVg65CM4a67t+kPQ=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies =
    with python3Packages;
    [
      ifuse
      libimobiledevice
      # Python dependencies
      pyqt5
      pygobject3
      gphoto2
      pyzmq
      tornado
      psutil
      pyxdg
      arrow
      python-dateutil
      easygui
      babel
      colour
      pillow
      pymediainfo
      sortedcontainers
      requests
      colorlog
      pyprind
      setuptools
      show-in-file-manager
      tenacity
    ]
    ++ lib.optional (pythonOlder "3.8") importlib-metadata;

  postPatch = ''
    # Drop broken version specifier
    sed -i '/python_requires/d' setup.py
    # Disable version check
    substituteInPlace raphodo/constants.py \
      --replace "disable_version_check = False" "disable_version_check = True"
  '';

  nativeBuildInputs = [
    libsForQt5.wrapQtAppsHook
    file
    intltool
    gobject-introspection
  ];

  # Package has no generally usable unit tests.
  # The included doctests expect specific, hardcoded hardware to be present.
  # Instead, we just make sure the program runs enough to report its version.
  checkPhase = ''
    export XDG_DATA_HOME=$(mktemp -d)
    export QT_QPA_PLATFORM=offscreen
    $out/bin/rapid-photo-downloader --detailed-version
  '';

  buildInputs = [
    gdk-pixbuf
    gexiv2
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gstreamer
    gst_all_1.gstreamer.dev
    libgudev
    libnotify
    udisks
  ];

  # NOTE: Check if strictDeps can be renabled
  # at the time of writing this the dependency easygui fails to build
  #       launching fails with:
  #       "Namespace [Notify / GExiv2 / GUdev] not available"
  strictDeps = false;

  preFixup = ''
    makeWrapperArgs+=(
      --set GI_TYPELIB_PATH "$GI_TYPELIB_PATH"
      --set PYTHONPATH "$PYTHONPATH"
      --prefix PATH : "${
        lib.makeBinPath [
          exiftool
          vmtouch
        ]
      }"
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libmediainfo ]}"
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"
      "''${qtWrapperArgs[@]}"
    )
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
    ignoredVersions = "a.*";
  };

  meta = {
    description = "Photo and video importer for cameras, phones, and memory cards";
    mainProgram = "rapid-photo-downloader";
    homepage = "https://www.damonlynch.net/rapid/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ philipdb ];
  };
}
