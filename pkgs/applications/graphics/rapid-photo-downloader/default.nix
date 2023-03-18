{ lib, mkDerivationWith, fetchFromGitHub, python3Packages
, file, intltool, gobject-introspection, libgudev
, udisks, gexiv2, gst_all_1, libnotify, ifuse, libimobiledevice
, exiftool, gdk-pixbuf, libmediainfo, vmtouch
}:

mkDerivationWith python3Packages.buildPythonApplication rec {
  pname = "rapid-photo-downloader";
  version = "0.9.34";

  src = fetchFromGitHub {
    owner = "damonlynch";
    repo = "rapid-photo-downloader";
    rev = "v${version}";
    hash = "sha256-4VC1fwQh9L3c5tgLUaC36p9QHL4dR2vkWc2XlNl0Xzw=";
  };

  postPatch = ''
    # Drop broken version specifier
    sed -i '/python_requires/d' setup.py
    # Disable version check
    substituteInPlace raphodo/constants.py \
      --replace "disable_version_check = False" "disable_version_check = True"
  '';

  nativeBuildInputs = [
    file
    intltool
  ];

  # Package has no generally usable unit tests.
  # The included doctests expect specific, hardcoded hardware to be present.
  # Instead, we just make sure the program runs enough to report its version.
  checkPhase = ''
    export XDG_DATA_HOME=$(mktemp -d)
    export QT_QPA_PLATFORM=offscreen
    $out/bin/rapid-photo-downloader --detailed-version
  '';

  # NOTE: Without gobject-introspection in buildInputs and strictDeps = false,
  #       launching fails with:
  #       "Namespace [Notify / GExiv2 / GUdev] not available"
  buildInputs = [
    gdk-pixbuf
    gexiv2
    gobject-introspection
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gstreamer
    gst_all_1.gstreamer.dev
    libgudev
    libnotify
    udisks
  ];

  strictDeps = false;

  propagatedBuildInputs = with python3Packages; [
    ifuse
    libimobiledevice
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
    pyheif
    pymediainfo
    sortedcontainers
    requests
    colorlog
    pyprind
    setuptools
    show-in-file-manager
    tenacity
  ] ++ lib.optional (pythonOlder "3.8") importlib-metadata;

  preFixup = ''
    makeWrapperArgs+=(
      --set GI_TYPELIB_PATH "$GI_TYPELIB_PATH"
      --set PYTHONPATH "$PYTHONPATH"
      --prefix PATH : "${lib.makeBinPath [ exiftool vmtouch ]}"
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libmediainfo ]}"
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"
      "''${qtWrapperArgs[@]}"
    )
  '';

  meta = with lib; {
    description = "Photo and video importer for cameras, phones, and memory cards";
    homepage = "https://www.damonlynch.net/rapid/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jfrankenau ];
  };
}
