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
  versionCheckHook,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "rapid-photo-downloader";
  version = "0.9.37";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "damonlynch";
    repo = "rapid-photo-downloader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-De4qe3LZm8fe5mu3teQzeP74mdgetCPRJrBzq9fad2s=";
  };

  build-system = with python3Packages; [
    hatchling
    hatch-argparse-manpage
    hatch-gettext
  ];

  dependencies = with python3Packages; [
    ifuse
    libimobiledevice
    # Python dependencies
    arrow
    babel
    colour
    gphoto2
    packaging
    pillow
    psutil
    pygobject3
    pymediainfo
    pyqt5
    python-dateutil
    pyxdg
    pyzmq
    show-in-file-manager
    sortedcontainers
    tenacity
    tornado
    # Optional dependencies
    colorlog
  ];

  nativeBuildInputs = [
    libsForQt5.wrapQtAppsHook
    file
    intltool
    gobject-introspection
  ];

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

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgramArg = "--detailed-version";
  # Keep and setup environment such that the detailed version check
  # can run successfully without a screen.
  # Next to that, set the XDG_CACHE_HOME to stop generating errors
  # about unwritable cache directories.
  versionCheckKeepEnvironment = [
    "QT_QPA_PLATFORM"
    "XDG_CACHE_HOME"
  ];
  preVersionCheck = ''
    export QT_QPA_PLATFORM=offscreen
    export XDG_CACHE_HOME=$(mktemp -d)
  '';

  strictDeps = true;

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

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^v([0-9.]+)$" ];
  };

  meta = {
    description = "Photo and video importer for cameras, phones, and memory cards";
    mainProgram = "rapid-photo-downloader";
    homepage = "https://www.damonlynch.net/rapid/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ philipdb ];
  };
})
