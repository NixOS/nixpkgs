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
  gst_all_1,
  withVLC ? stdenv.hostPlatform.isLinux,
}:

python3Packages.buildPythonApplication rec {
  pname = "pympress";
  version = "1.8.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cimbali";
    repo = "pympress";
    tag = "v${version}";
    hash = "sha256-rIlYd5SMWYeqdMHyW3d1ggKnUMCJCDP5uw25d7zG2DU=";
  };

  build-system = with python3Packages; [
    setuptools
    babel
  ];

  patches = [
    # Workaround for a bug on Python >= 3.13+ and pygobject < 3.51.
    # This can go away once nixpkgs is using pygobject >= 3.51.
    # See <https://github.com/Cimbali/pympress/issues/330> for details.
    ./issue-330-gprops-iter-actually-iterable.patch
  ];

  dependencies =
    with python3Packages;
    [
      watchdog
      pycairo
      pygobject3
    ]
    ++ lib.optional withVLC [
      python-vlc
    ];

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
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    (gst_all_1.gst-plugins-good.override { gtkSupport = true; })
    gst_all_1.gst-libav
    gst_all_1.gst-vaapi
  ];

  doCheck = false; # there are no tests

  pythonImportsCheck = [ "pympress" ];

  meta = {
    description = "Simple yet powerful PDF reader designed for dual-screen presentations";
    mainProgram = "pympress";
    license = lib.licenses.gpl2Plus;
    homepage = "https://cimbali.github.io/pympress/";
    maintainers = with lib.maintainers; [ tbenst ];
  };
}
