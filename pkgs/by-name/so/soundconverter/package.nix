{
  lib,
  # Optional due to unfree license.
  faacSupport ? false,
  fetchFromGitHub,
  glib,
  python3Packages,
  gtk3,
  wrapGAppsHook3,
  gsettings-desktop-schemas,
  intltool,
  xvfb-run,
  gobject-introspection,
  gst_all_1,
  fdk-aac-encoder,
}:

python3Packages.buildPythonApplication rec {
  pname = "soundconverter";
  version = "4.1.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "kassoulet";
    repo = "soundconverter";
    tag = version;
    hash = "sha256-EyiptrbtlSk64zNAZrNz0FxSLUlwG3TKs/AR6gyCG6w=";
  };

  buildInputs = [
    gtk3
    fdk-aac-encoder
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    (gst_all_1.gst-plugins-bad.override { inherit faacSupport; })
  ];

  nativeBuildInputs = [
    intltool
    wrapGAppsHook3
    gobject-introspection
  ];

  dependencies = with python3Packages; [
    gst-python
    distutils-extra
    setuptools
    pygobject3
  ];

  nativeCheckInputs = [ xvfb-run ];

  postPatch = ''
    substituteInPlace  bin/soundconverter --replace-fail \
      "data/soundconverter.glade" \
      "$out/share/soundconverter/soundconverter.glade"
  '';

  # Necessary to set GDK_PIXBUF_MODULE_FILE.
  strictDeps = false;

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

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
    maintainers = with lib.maintainers; [
      jakubgs
      aleksana
    ];
  };
}
