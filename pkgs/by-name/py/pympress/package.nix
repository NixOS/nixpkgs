{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  wrapGAppsHook3,
  gtk3,
  gobject-introspection,
  libcanberra-gtk3,
  poppler_gi,
  withGstreamer ? stdenv.hostPlatform.isLinux,
  gstreamer,
  gst-plugins-ugly,
  gst-plugins-good,
  gst-plugins-base,
  gst-plugins-bad,
  gst-libav,
  withVLC ? stdenv.hostPlatform.isLinux,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pympress";
  version = "1.8.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cimbali";
    repo = "pympress";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rIlYd5SMWYeqdMHyW3d1ggKnUMCJCDP5uw25d7zG2DU=";
  };

  build-system = with python3Packages; [
    setuptools
    babel
  ];

  dependencies =
    with python3Packages;
    [
      watchdog
      pycairo
      pygobject3
    ]
    ++ lib.optional withVLC python-vlc;

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    poppler_gi
  ]
  ++ lib.optionals withGstreamer [
    libcanberra-gtk3
    gstreamer
    gst-plugins-base
    gst-plugins-bad
    gst-plugins-ugly
    (gst-plugins-good.override { gtkSupport = true; })
    gst-libav
  ];

  doCheck = false; # there are no tests

  pythonImportsCheck = [ "pympress" ];

  meta = {
    description = "Simple yet powerful PDF reader designed for dual-screen presentations";
    mainProgram = "pympress";
    license = lib.licenses.gpl2Plus;
    homepage = "https://cimbali.github.io/pympress/";
    maintainers = [ ];
  };
})
