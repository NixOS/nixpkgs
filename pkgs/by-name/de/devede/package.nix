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
  nix-update-script,
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
  format = "pyproject";
  namePrefix = "";

  src = fetchFromGitLab {
    owner = "rastersoft";
    repo = "devedeng";
    rev = finalAttrs.version;
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
    substituteInPlace setup.py --replace "'/usr'," ""
    substituteInPlace src/devedeng/configuration_data.py \
      --replace "/usr/share" "$out/share" \
      --replace "/usr/local/share" "$out/share"
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "DVD Creator for Linux";
    homepage = "https://www.rastersoft.com/programas/devede.html";
    license = lib.licenses.gpl3;
    maintainers = [
      lib.maintainers.bdimcheff
      lib.maintainers.baksa
    ];
  };
})
