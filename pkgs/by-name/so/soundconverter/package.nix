{ lib, fetchurl
# Optional due to unfree license.
, faacSupport ? false
, glib, python3Packages, gtk3, wrapGAppsHook3
, gsettings-desktop-schemas, intltool, xvfb-run
, gobject-introspection, gst_all_1, fdk-aac-encoder }: let

pythonWrapPackages = [
  python3Packages.gst-python
  python3Packages.distutils-extra
  python3Packages.setuptools
  python3Packages.pygobject3
];
in python3Packages.buildPythonApplication rec {
  pname = "soundconverter";
  version = "4.0.5";

  src = fetchurl {
    url = "https://launchpad.net/soundconverter/trunk/${version}/+download/${pname}-${version}.tar.gz";
    hash = "sha256-ebBaNmhd3OXeJPCiPQjgCgFO2J5ilx/pTB0/uDbrefM=";
  };

  buildInputs = [
    gtk3
    fdk-aac-encoder
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    (gst_all_1.gst-plugins-bad.override { inherit faacSupport; })
  ] ++ pythonWrapPackages;

  nativeBuildInputs = [
    intltool
    wrapGAppsHook3
    gobject-introspection
  ];

  nativeCheckInputs = [ xvfb-run ];

  postPatch = ''
    substituteInPlace  bin/soundconverter --replace-fail \
      "DATA_PATH = os.path.join(SOURCE_PATH, 'data')" \
      "DATA_PATH = '$out/share/soundconverter'"
  '';

  preCheck = let
    self = { outPath = "$out"; name = "${pname}-${version}"; };
    xdgPaths = lib.concatMapStringsSep ":" glib.getSchemaDataDirPath;
  in ''
    export HOME=$TMPDIR
    export XDG_DATA_DIRS=$XDG_DATA_DIRS:${xdgPaths [gtk3 gsettings-desktop-schemas self]}
    # FIXME: Fails due to weird Gio.file_parse_name() behavior.
    sed -i '49 a\    @unittest.skip("Gio.file_parse_name issues")' tests/testcases/names.py
  '' + lib.optionalString (!faacSupport) ''
    substituteInPlace tests/testcases/gui_integration.py --replace-warn \
      "for encoder in ['fdkaacenc', 'faac', 'avenc_aac']:" \
      "for encoder in ['fdkaacenc', 'avenc_aac']:"
  '';

  checkPhase = ''
    runHook preCheck
    xvfb-run python tests/test.py
    runHook postCheck
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
    makeWrapperArgs+=(--prefix PYTHONPATH : ${python3Packages.makePythonPath pythonWrapPackages})
  '';

  # Necessary to set GDK_PIXBUF_MODULE_FILE.
  strictDeps = false;

  meta = {
    homepage = "https://soundconverter.org/";
    description = "Leading audio file converter for the GNOME Desktop";
    mainProgram = "soundconverter";
    longDescription = ''
      SoundConverter reads anything the GStreamer library can read,
      and writes WAV, FLAC, MP3, AAC and Ogg Vorbis files.
      Uses Python and GTK+ GUI toolkit, and runs on X Window System.
    '';
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ jakubgs pyrox0 ];
  };
}
