{ stdenv, fetchurl, python3Packages
, file, intltool, gobject-introspection, libgudev
, udisks, gexiv2, gst_all_1, libnotify
, exiftool, gdk_pixbuf, libmediainfo
}:

python3Packages.buildPythonApplication rec {
  pname = "rapid-photo-downloader";
  version = "0.9.14";

  src = fetchurl {
    url = "https://launchpad.net/rapid/pyqt/${version}/+download/${pname}-${version}.tar.gz";
    sha256 = "1nywkkyxlpzq3s9anza9k67j5689pfclfha218frih36qdb0j258";
  };

  # Disable version check and fix install tests
  postPatch = ''
    substituteInPlace raphodo/constants.py \
      --replace "disable_version_check = False" "disable_version_check = True"
    substituteInPlace raphodo/rescan.py \
      --replace "from preferences" "from raphodo.preferences"
  '';

  nativeBuildInputs = [
    file
    intltool
  ];

  # Package has no generally usable unit tests.
  # The included doctests expect specific, hardcoded hardware to be present.
  doCheck = false;

  # NOTE: Without gobject-introspection in buildInputs, launching fails with
  #       "Namespace [Notify / GExiv2 / GUdev] not available"
  buildInputs = [
    gdk_pixbuf
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

  propagatedBuildInputs = with python3Packages; [
    pyqt5
    pygobject3
    gphoto2
    pyzmq
    tornado
    psutil
    pyxdg
    arrow
    dateutil
    easygui
    colour
    pymediainfo
    sortedcontainers
    rawkit
    requests
    colorlog
    pyprind
  ];

  makeWrapperArgs = [
    "--set GI_TYPELIB_PATH \"$GI_TYPELIB_PATH\""
    "--set PYTHONPATH \"$PYTHONPATH\""
    "--prefix PATH : ${stdenv.lib.makeBinPath [ exiftool ]}"
    "--prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [ libmediainfo ]}"
    "--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : \"$GST_PLUGIN_SYSTEM_PATH_1_0\""
  ];

  meta = with stdenv.lib; {
    description = "Photo and video importer for cameras, phones, and memory cards";
    homepage = http://www.damonlynch.net/rapid/;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jfrankenau ];
  };
}
