{
  lib,
  fetchFromGitLab,
  python3Packages,
  ffmpeg,
  mplayer,
  vcdimager,
  cdrkit,
  dvdauthor,
  gtk3,
  wrapGAppsHook3,
  gdk-pixbuf,
  gobject-introspection,
  # The subtitle encoder and mixer 'spumux' looks for the font 'arial' by default (hardcoded in devede)
  # and it should be made available to that program in the user environment or it throws an error.
  # If overrideFont is true we instead use a particular font file in the nix store,
  # which is always available by design.
  overrideFont ? true,
  liberation_ttf,
  fontPath ? "${liberation_ttf}/share/fonts/truetype/LiberationSans-Regular.ttf",
}:

let
  inherit (python3Packages)
    dbus-python
    buildPythonApplication
    pygobject3
    urllib3
    setuptools
    setuptools-gettext
    importlib-metadata
    ;
in
buildPythonApplication (finalAttrs: {
  pname = "devede";
  version = "4.21.3.1";
  pyproject = true;
  namePrefix = "";

  src = fetchFromGitLab {
    owner = "rastersoft";
    repo = "devedeng";
    tag = finalAttrs.version;
    hash = "sha256-81H063PpBF/+JDsRgBLwfAevb11yNkDtH4KdtOAL/Fg=";
  };

  nativeBuildInputs = [
    setuptools-gettext
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    ffmpeg
  ];

  propagatedBuildInputs = [
    gtk3
    pygobject3
    gdk-pixbuf
    dbus-python
    ffmpeg
    mplayer
    dvdauthor
    vcdimager
    cdrkit
    urllib3
    setuptools
    importlib-metadata
  ];

  postPatch = ''
    substituteInPlace src/devedeng/configuration_data.py \
      --replace-fail "/usr/share" "$out/share" \
      --replace-fail "/usr/local/share" "$out/share"
  ''
  + lib.optionalString overrideFont ''
    substituteInPlace src/devedeng/subtitles_mux.py \
      --replace-fail arial ${fontPath}
  '';

  # Prevent double wrapping, let the Python wrapper use the args in preFixup.
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "DVD Creator for Linux";
    mainProgram = "devede_ng";
    homepage = "https://www.rastersoft.com/programas/devede.html";
    license = lib.licenses.gpl3;
    maintainers = [
      lib.maintainers.bdimcheff
      lib.maintainers.baksa
    ];
  };
})
